output "resource_group_name" {
  description = "O nome do grupo de recursos principal."
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "A região do Azure onde os recursos foram criados."
  value       = azurerm_resource_group.rg.location
}

output "vnet_id" {
  description = "O ID da Rede Virtual principal."
  value       = azurerm_virtual_network.vnet.id
}

output "aks_subnet_id" {
  description = "O ID da sub-rede do AKS."
  value       = azurerm_subnet.aks_subnet.id
}

output "app_subnet_id" {
  description = "O ID da sub-rede das aplicações."
  value       = azurerm_subnet.app_subnet.id
}

output "terraform_state_storage_account_name" {
  description = "O nome da conta de armazenamento para o estado do Terraform."
  value       = azurerm_storage_account.terraform_state.name
}

output "terraform_state_container_name" {
  description = "O nome do contêiner para o estado do Terraform."
  value       = azurerm_storage_container.terraform_state.name
}