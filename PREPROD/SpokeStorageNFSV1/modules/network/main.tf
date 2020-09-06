#VNET AND Subnet for Hub 
resource "azurerm_virtual_network" "hub-corpc-vnet" {
    name                = "${var.current-name-convention-core-module}-vnet"
    location            = "${var.preferred-location-module}"
    resource_group_name = "${var.current-name-convention-core-module}-rg"
    address_space       = ["${var.ip-range-module}"]
    depends_on = [var.vnet_depend_on_module]
    tags = "${var.tags-vnet-module}" 
}


