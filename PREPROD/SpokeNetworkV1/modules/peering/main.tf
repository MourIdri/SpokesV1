#provider "azurerm" {
  #features {}
  #alias = "subscription1"
  #subscription_id = "xxxxxxx"
#}

#provider "azurerm" {
#  features {}

#  alias = "subscription2"
#  subscription_id = "xxxxxxx"
#}

#Remote VNET import
data "azurerm_virtual_network" "remote_vnet" {
  #provider = azurerm.subscription1
  #name = "cc-pp-hb-vnet"
  name = "${var.current-name-convention-core-hub-module}-vnet"
  #resource_group_name = "cc-pp-hb-rg"
  resource_group_name = "${var.current-name-convention-core-hub-module}-rg"
}
#Local VNET import
#data "azurerm_virtual_network" "local_vnet" {
  #provider = azurerm.subscription2
  #name = "cc-pp-nt-vnet"
  #name = "${var.current-name-convention-core-module}-vnet"
  #resource_group_name = "cc-pp-nt-rg"
  #resource_group_name = "${var.current-name-convention-core-module}-rg"
#}

resource "azurerm_virtual_network_peering" "peering_on_local" {
  depends_on = [var.vnet_peering_depend_on_module, data.azurerm_virtual_network.remote_vnet]
  #provider = azurerm.subscription2
  name                         = "${var.current-name-convention-core-module}-vnet-to-${data.azurerm_virtual_network.remote_vnet.name}"
  resource_group_name          = "${var.current-name-convention-core-module}-rg"
  #resource_group_name          = "cc-pp-nt-rg"
  virtual_network_name         = "${var.current-name-convention-core-module}-vnet"
  #virtual_network_name         = data.azurerm_virtual_network.local_vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.remote_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  # `allow_gateway_transit` must be set to false for vnet Global Peering
  #allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "peering_on_remote" {
  depends_on = [var.vnet_peering_depend_on_module, data.azurerm_virtual_network.remote_vnet]
  #provider = azurerm.subscription1
  name                         = "${data.azurerm_virtual_network.remote_vnet.name}-to-${var.current-name-convention-core-module}-vnet"
  resource_group_name          = "${var.current-name-convention-core-hub-module}-rg"
  #resource_group_name          = "cc-pp-hb-rg"
  virtual_network_name         = data.azurerm_virtual_network.remote_vnet.name
  remote_virtual_network_id    = "${var.nt-workload-vnet-id-module}"
  #remote_virtual_network_id    = data.azurerm_virtual_network.local_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  # `allow_gateway_transit` must be set to false for vnet Global Peering
  #allow_gateway_transit = false
}