resource "azurerm_resource_group" "HubRG" {
  name     = "${var.base_name}RG"
  location = var.location
}