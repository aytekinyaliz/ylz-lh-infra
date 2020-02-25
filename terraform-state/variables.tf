variable "azure_subscription_id" {
  description = "Azure substitution id."
}

variable "azure_sp_client_id" {
  description = "Application ID/Client ID  of the service principal. Used by AKS to manage AKS related resources on Azure like vms, subnets."
}

variable "azure_sp_client_secret" {
  description = "Azure service principal password. Used by AKS to manage Azure."
}

variable "azure_sp_tenant_id" {
  description = "Azure service principal tenant_id."
}

variable "env" {
  default = "Development"
}

variable "location" {
  default = "eastus"
}
variable "resource_group_name_storage" {
  description = "Name of the resource group for storage."
  default     = "rg-st-ylz-lh"
}

variable "st_acc_name" {
  default = "sttrylz-lh"
}
variable "storage_container_name" {
  default = "tfstate"
}

variable "storage_account_acc_tier" {
  default = "Standard"
}

variable "storage_account_account_replication_type" {
  default = "GRS"
}
