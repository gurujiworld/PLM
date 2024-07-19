variable "base_name" {
  type        = string
  description = "base name for plm host"
}

variable "location" {
  type        = string
  description = "location for plm server"
}

variable "resource_group_name" {
  type        = string
  description = "rg for azurerm_plm_host"
}

variable "virtual_network_name" {
  description = "vnet name for plm host"
}

variable "address_prefixes" {
  type        = list(string)
  description = "cidr for spoke subnet"
}