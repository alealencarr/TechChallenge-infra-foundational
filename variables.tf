variable "resource_group_name" {
  type        = string
  description = "O nome do grupo de recursos principal para a aplicação."
  default     = "rg-tchungry-prod"
}

variable "location" {
  type        = string
  description = "A região do Azure onde os recursos serão criados."
  default     = "Brazil South"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "O espaço de endereço IP para a Rede Virtual."
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_prefix" {
  type        = list(string)
  description = "O prefixo de endereço para a sub-rede do AKS."
  default     = ["10.0.1.0/24"]
}

variable "app_subnet_prefix" {
  type        = list(string)
  description = "O prefixo de endereço para a sub-rede das aplicações (APIM, Functions)."
  default     = ["10.0.2.0/24"]
}

variable "terraform_state_storage_account_name" {
  type        = string
  description = "Nome globalmente único para a conta de armazenamento do estado do Terraform."
  default     = "tfstatetchungryale"
}