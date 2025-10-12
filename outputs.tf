output "resource_group_name" {
  description = "O nome do grupo de recursos principal."
  value       = azurerm_resource_group.app_rg.name
}

output "location" {
  description = "A região do Azure onde os recursos foram criados."
  value       = azurerm_resource_group.app_rg.location
}

output "vnet_id" {
  description = "O ID da Rede Virtual principal."
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "O nome da Rede Virtual principal."
  value       = azurerm_virtual_network.vnet.name
}

output "aks_subnet_id" {
  description = "O ID da sub-rede do AKS."
  value       = azurerm_subnet.aks_subnet.id
}

output "aks_subnet_name" {
  description = "O nome da sub-rede do AKS."
  value       = azurerm_subnet.aks_subnet.name
}

output "app_subnet_id" {
  description = "O ID da sub-rede das aplicações (Application Gateway)."
  value       = azurerm_subnet.app_subnet.id
}

output "app_subnet_name" {
  description = "O nome da sub-rede das aplicações."
  value       = azurerm_subnet.app_subnet.name
}

output "apim_subnet_id" {
  description = "O ID da sub-rede do APIM."
  value       = azurerm_subnet.apim_subnet.id
}

output "apim_subnet_name" {
  description = "O nome da sub-rede do APIM."
  value       = azurerm_subnet.apim_subnet.name
}

output "private_endpoints_subnet_id" {
  description = "O ID da sub-rede de Private Endpoints."
  value       = azurerm_subnet.private_endpoints_subnet.id
}

output "private_endpoints_subnet_name" {
  description = "O nome da sub-rede de Private Endpoints."
  value       = azurerm_subnet.private_endpoints_subnet.name
}

output "terraform_state_storage_account_name" {
  description = "O nome da conta de armazenamento para o estado do Terraform."
  value       = azurerm_storage_account.terraform_state_storage.name
}

output "terraform_state_container_name" {
  description = "O nome do contêiner para o estado do Terraform."
  value       = azurerm_storage_container.terraform_state_container.name
}

