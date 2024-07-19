terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  address_space = ["10.0.0.0/16"]
}

module "rg-hub" {
  source    = "./modules/rg"
  base_name = "hcl-hub"
  location  = "Central India"
}

module "rg-spoke" {
  source    = "./modules/rg"
  base_name = "hcl-spoke"
  location  = "Central India"
}

module "vnet-hub" {
  source              = "./modules/vnet"
  base_name           = "hub-vnet"
  resource_group_name = module.rg-hub.rg_name_out
  location            = module.rg-hub.rg_location_out
  address_space       = ["10.0.0.0/16"]
}

module "vnet-spoke" {
  source              = "./modules/vnet"
  base_name           = "spoke-vnet"
  resource_group_name = module.rg-spoke.rg_name_out
  location            = module.rg-spoke.rg_location_out
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = module.rg-hub.rg_name_out
  virtual_network_name      = module.vnet-hub.vnet_name_out
  remote_virtual_network_id = module.vnet-spoke.vnet_id_out
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer-spoke-to-hub"
  resource_group_name       = module.rg-spoke.rg_name_out
  virtual_network_name      = module.vnet-spoke.vnet_name_out
  remote_virtual_network_id = module.vnet-hub.vnet_id_out
}

module "bastion" {
  source               = "./modules/bastionhost"
  base_name            = "bastionhosthcl"
  location             = module.rg-hub.rg_location_out
  resource_group_name  = module.rg-hub.rg_name_out
  virtual_network_name = module.vnet-hub.vnet_name_out
}

module "firewall" {
  source               = "./modules/firewall"
  location             = module.rg-hub.rg_location_out
  resource_group_name  = module.rg-hub.rg_name_out
  virtual_network_name = module.vnet-hub.vnet_name_out
}

module "vm" {
  source               = "./modules/vm"
  location             = module.rg-spoke.rg_location_out
  resource_group_name  = module.rg-spoke.rg_name_out
  virtual_network_name = module.vnet-spoke.vnet_name_out
  base_name            = "plm-vm"
  address_prefixes     = ["192.168.1.0/24"]
}

module "plm-appgwt" {
  source               = "./modules/app-gwt"
  resource_group_name  = module.rg-spoke.rg_name_out
  virtual_network_name = module.vnet-spoke.vnet_name_out
  address_prefixes     = ["192.168.2.0/27"]
  location             = module.rg-spoke.rg_location_out
  network_interface_id = module.vm.nic_id_out
}