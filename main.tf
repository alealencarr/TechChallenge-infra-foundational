terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# 1. Cria o Grupo de Recursos principal da aplicação
resource "azurerm_resource_group" "app_rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Cria a Rede Virtual (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-tchungry-prod"
  resource_group_name = azurerm_resource_group.app_rg.name
  location            = azurerm_resource_group.app_rg.location
  address_space       = var.vnet_address_space
}

# 3. Cria a sub-rede para o AKS
resource "azurerm_subnet" "aks_subnet" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.app_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aks_subnet_prefix
}

# 3a. Cria a sub-rede para Private Endpoints
resource "azurerm_subnet" "private_endpoints_subnet" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.app_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.privateendpoints_subnet_prefix
}

# 4. Cria a sub-rede para as outras aplicações (Application Gateway, Functions)
resource "azurerm_subnet" "app_subnet" {
  name                 = "snet-apps"
  resource_group_name  = azurerm_resource_group.app_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.app_subnet_prefix
}

# 5. Cria a sub-rede exclusiva para o APIM
resource "azurerm_subnet" "apim_subnet" {
  name                 = "snet-apim"
  resource_group_name  = azurerm_resource_group.app_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# 6. Cria o Network Security Group para a sub-rede do APIM
resource "azurerm_network_security_group" "apim_subnet_nsg" {
  name                = "nsg-snet-apim"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name

  # Regra 1: Management do APIM (porta 3443)
  security_rule {
    name                       = "AllowApiManagement"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }

  # Regra 2: HTTPS da Internet (porta 443) - CRÍTICO!
  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }

  # Regra 3: Azure Load Balancer (necessário pro APIM)
  security_rule {
    name                       = "AllowAzureLoadBalancer"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  }

  # Regra 4: Outbound - APIM precisa acessar backends
  security_rule {
    name                       = "AllowAPIMToBackends"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443", "1433", "3306"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

# 7. Associa o NSG à sub-rede do APIM
resource "azurerm_subnet_network_security_group_association" "apim_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.apim_subnet.id
  network_security_group_id = azurerm_network_security_group.apim_subnet_nsg.id
}

# 8. Cria um Grupo de Recursos SEPARADO para o estado do Terraform
resource "azurerm_resource_group" "terraform_state_rg" {
  name     = "rg-terraform-state"
  location = var.location
}

# 9. Cria a Conta de Armazenamento para o backend de estado remoto
resource "azurerm_storage_account" "terraform_state_storage" {
  name                     = var.terraform_state_storage_account_name
  resource_group_name      = azurerm_resource_group.terraform_state_rg.name
  location                 = azurerm_resource_group.terraform_state_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 10. Cria o Contêiner dentro da conta de armazenamento
resource "azurerm_storage_container" "terraform_state_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.terraform_state_storage.name
  container_access_type = "private"
}