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

# 4. Cria a sub-rede para as outras aplicações (APIM, Functions)
resource "azurerm_subnet" "app_subnet" {
  name                 = "snet-apps"
  resource_group_name  = azurerm_resource_group.app_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.app_subnet_prefix
}


# 5. Cria um Grupo de Recursos SEPARADO para o estado do Terraform
resource "azurerm_resource_group" "terraform_state_rg" {
  name     = "rg-terraform-state"
  location = var.location
}

# 6. Cria a Conta de Armazenamento para o backend de estado remoto
resource "azurerm_storage_account" "terraform_state_storage" {
  name                     = var.terraform_state_storage_account_name
  resource_group_name      = azurerm_resource_group.terraform_state_rg.name
  location                 = azurerm_resource_group.terraform_state_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 7. Cria o Contêiner dentro da conta de armazenamento
resource "azurerm_storage_container" "terraform_state_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.terraform_state_storage.name
  container_access_type = "private"
}

