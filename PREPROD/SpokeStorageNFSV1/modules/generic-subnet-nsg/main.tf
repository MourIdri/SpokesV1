#create subnet 
resource "azurerm_subnet" "subnet-iac" {
  name                = "${var.current-name-convention-core-module}-subnet-${var.root-name-subnet-module}"
  resource_group_name  = "${var.current-name-convention-core-module}-rg"
  virtual_network_name = "${var.current-name-convention-core-module}-vnet"
  address_prefix       = "${var.iprange-subnet-module}"
  depends_on = [var.subnet_depend_on_module]
  
} 


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg-iac" {
    depends_on = [var.subnet_depend_on_module]
    name                = "${var.current-name-convention-core-module}-subnet-${var.root-name-subnet-module}-nsg"
    location            = "${var.preferred-location-module}" 
    resource_group_name = "${var.current-name-convention-core-module}-rg"
    security_rule {
        name                       = "nsgruleallowdefault"
        priority                   = 4001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_ranges     = "${var.portrange-subnet-module}" 
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}
resource "azurerm_subnet_network_security_group_association" "subnet-nsg-assoc-iac" {
  subnet_id                 = azurerm_subnet.subnet-iac.id
  network_security_group_id = azurerm_network_security_group.nsg-iac.id
}


resource "azurerm_route_table" "route-nva-iac" {
  name                          = "route-table-${var.root-name-subnet-module}"
  location                      = "${var.preferred-location-module}" 
  resource_group_name           = "${var.current-name-convention-core-module}-rg"
  disable_bgp_route_propagation = false

  route {
    name           = "route-table-${var.root-name-subnet-module}-to-nva-default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${var.nva-ip-out-to-spoke-module}"
  }
}
resource "azurerm_subnet_route_table_association" "route-nva-subnet-asso-iac" {
  subnet_id      = azurerm_subnet.subnet-iac.id
  route_table_id = azurerm_route_table.route-nva-iac.id
}

output "durty-temp-outupt0" {
  value = "${var.preferred-location-module}" 
}
output "durty-temp-outupt1" {
  value ="${var.current-name-convention-core-public-module}"  
}