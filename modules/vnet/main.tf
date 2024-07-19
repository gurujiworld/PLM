resource "azurerm_virtual_network" "hub-vnet" {
  name                = var.base_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

