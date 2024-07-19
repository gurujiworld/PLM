variable "base_name" {
  type        = string
  description = "base name for bastion host"
}

variable "location" {
  type        = string
  description = "location for AzureBastionSubnet"
}

variable "resource_group_name" {
  type        = string
  description = "rg for azurerm_bastion_host"
}

variable "virtual_network_name" {
  description = "vnet name for bastion host"
}
