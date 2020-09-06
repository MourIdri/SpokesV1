#create subnet 
resource "azurerm_subnet" "subnet-iac" {
  name                 = "${var.current-name-convention-core-submodule}-subnet-${var.subnet-subroot-name-submodule}"
  resource_group_name  = "${var.current-name-convention-core-submodule}-rg"
  virtual_network_name = "${var.current-name-convention-core-submodule}-vnet"
  address_prefix       = "${var.subnet-ip-range-convention-core-submodule}"
  depends_on = [var.subnet_depend_on_submodule]
  
}

output "durty-temp-outupttt" {
  value = "${var.preferred-location-submodule}" 
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg-iac" {
    name                = "${var.current-name-convention-core-submodule}-subnet-${var.subnet-subroot-name-submodule}-nsg"
    location            = "${var.preferred-location-submodule}" 
    resource_group_name = "${var.current-name-convention-core-submodule}-rg"
    security_rule {
        name                       = "nsgruleallowdefault"
        priority                   = 4001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_ranges     = "${var.subnet-mgmt-port-range-submodule}" 
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}
