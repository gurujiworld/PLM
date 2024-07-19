variable "resource_group_name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "address_prefixes" {
  type = list(string)
}

variable "location" {
  type = string
}

variable "network_interface_id" {
  type = string
}