
resource "azurerm_subnet" "firewall-subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "firewall-pub-ip" {
  name                = "testpip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "hub-firewall" {
  name                = "testfirewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall-subnet.id
    public_ip_address_id = azurerm_public_ip.firewall-pub-ip.id
  }
}