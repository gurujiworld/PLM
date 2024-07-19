
resource "azurerm_subnet" "public" {
  name                 = "vm-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
}


resource "azurerm_network_interface" "main" {
  name                = "hcl-vm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "hcl-nsg" {
  name                = "hcl_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_network_interface.main
  ]
}

resource "azurerm_network_security_rule" "http" {
  name                        = "Allow-HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "103.174.76.24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.hcl-nsg.name

  depends_on = [
    azurerm_network_security_group.hcl-nsg
  ]
}

resource "azurerm_network_security_rule" "https" {
  name                        = "Allow-HTTPs"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "103.174.76.24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.hcl-nsg.name

  depends_on = [
    azurerm_network_security_group.hcl-nsg
  ]
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "Allow-ssh"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "103.174.76.24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.hcl-nsg.name

  depends_on = [
    azurerm_network_security_group.hcl-nsg
  ]
}



resource "azurerm_linux_virtual_machine" "hcl-vm" {
  name                = var.base_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.main.id
  ]

  admin_ssh_key {
    username    = "adminuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = {
    environment = "staging"
  }

  depends_on = [
    azurerm_network_interface.main
  ]

  custom_data = base64encode(templatefile("${path.module}/script.sh", {}))
}