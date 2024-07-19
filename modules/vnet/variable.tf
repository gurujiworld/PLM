variable "base_name" {
  type        = string
  description = "vnet name"
}

variable "resource_group_name" {
  type        = string
  description = "this is for resource_group_name"
}

variable "location" {
  type        = string
  description = "this is for vnet location"
}

variable "address_space" {
  type        = list(string)
  description = "CIDR for vnet"
}