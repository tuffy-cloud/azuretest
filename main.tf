provider "azurerm" {
  version = "=1.5.0"
}

resource "azurerm_resource_group" "tuffner_vnet" {
  name     = "tuffner_vnet"
  location = "West US"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  location            = "West US"
  address_space       = ["10.0.0.0/24"]
  resource_group_name = "${azurerm_resource_group.tuffner_vnet.name}"

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.0.0/24"
  }
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet2"
  location            = "West US"
  address_space       = ["192.168.0.0/24"]
  resource_group_name = "${azurerm_resource_group.tuffner_vnet.name}"

  subnet {
    name           = "subnet1"
    address_prefix = "192.168.0.0/24"
  }
}

resource "azurerm_virtual_network_peering" "peer1" {
  name                         = "vNet1-to-vNet2"
  resource_group_name          = "${azurerm_resource_group.tuffner_vnet.name}"
  virtual_network_name         = "${azurerm_virtual_network.vnet1.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.vnet2.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                         = "vNet2-to-vNet1"
  resource_group_name          = "${azurerm_resource_group.tuffner_vnet.name}"
  virtual_network_name         = "${azurerm_virtual_network.vnet2.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.vnet1.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}


