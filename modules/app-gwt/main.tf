resource "azurerm_subnet" "app-gateway-subnet" {
  name                 = "appgwtsubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_public_ip" "appgwt-pub-ip" {
  name                = "appgwt-pip"
  sku                 = "Standard"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "appgwt" {
  name                = "spoke-appgateway"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.app-gateway-subnet.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgwt-pip"
    public_ip_address_id = azurerm_public_ip.appgwt-pub-ip.id
  }

  backend_address_pool {
    name = "plm-web-tier"
  }

  backend_http_settings {
    name                  = "http-backend"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "web-tier"
    frontend_ip_configuration_name = "appgwt-pip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "web-tire-route"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "web-tier"
    backend_address_pool_name  = "plm-web-tier"
    backend_http_settings_name = "http-backend"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "example" {
  network_interface_id    = var.network_interface_id
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = tolist(azurerm_application_gateway.appgwt.backend_address_pool).0.id
}