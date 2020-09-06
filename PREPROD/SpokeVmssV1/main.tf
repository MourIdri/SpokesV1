data "azurerm_client_config" "current" {}
output "current_client_id" {
  value = data.azurerm_client_config.current.client_id
}
output "current_tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
output "current_subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
output "current_object_id" {
  value = data.azurerm_client_config.current.object_id
}

resource "azurerm_resource_group" "existing_terraform_rg" {
  name                     = "rg-ict-spoke1-001"
  location                 = "westeurope"
  #depends_on = [var.rg_depends_on]
}
# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.existing_terraform_rg.name
    location                    = "westeurope"
    account_tier                = "Standard"
    account_replication_type    = "LRS"
}
resource "azurerm_virtual_network" "existing_terraform_vnet" {
    name                = "vnet-spoke1-001"
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.existing_terraform_rg.name
    address_space       = ["10.100.0.0/24"]
    #depends_on = [azurerm_resource_group.existing_terraform_rg]
}
// Subnets
# Create subnet
resource "azurerm_subnet" "spk1-jbx-subnet" {
    name                 = "spk1-jbx-subnet"
    resource_group_name  = azurerm_resource_group.existing_terraform_rg.name
    virtual_network_name = azurerm_virtual_network.existing_terraform_vnet.name
    address_prefixes       = ["10.100.0.0/27"]
}

resource "azurerm_subnet" "new_terraform_subnet_web" {
  name                 = "snet-webtier-vdc-001"
  resource_group_name  =  azurerm_resource_group.existing_terraform_rg.name
  virtual_network_name =  azurerm_virtual_network.existing_terraform_vnet.name
  address_prefixes       = ["10.100.0.32/27"]
  depends_on = [azurerm_virtual_network.existing_terraform_vnet]
}

resource "azurerm_subnet" "new_terraform_subnet_frontwaf" {
  name                 = "snet-frontwaftier-vdc-001"
  resource_group_name  =  azurerm_resource_group.existing_terraform_rg.name
  virtual_network_name =  azurerm_virtual_network.existing_terraform_vnet.name
  address_prefixes       = ["10.100.0.64/27"]
  depends_on = [azurerm_virtual_network.existing_terraform_vnet]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "generic-nsg" {
    name                = "generic-nsg"
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.existing_terraform_rg.name
    security_rule {
        name                       = "GENERIC-RULE-FOR-PRIVATE-ACCESS"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        #destination_port_range     = "3389"
        #destination_port_ranges     = "["22","3389","80","8080"]" 
        destination_port_ranges     = ["22","3389","80","8080","443"]
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "generic-nsg-internet" {
    name                = "generic-nsg-internet"
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.existing_terraform_rg.name
    security_rule {
        name                       = "GENERIC-RULE-FOR-PREVENT-INTERNET-ACCESS-LOCAL"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        #destination_port_range     = "3389"
        #destination_port_ranges     = "["22","3389","80","8080"]" 
        destination_port_ranges     = ["22","3389","80","8080","443"]
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "GENERIC-RULE-FOR-PREVENT-INTERNET-ACCESS-OUT"
        priority                   = 1013
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        #destination_port_ranges     = "["22","3389","80","8080"]" 
        #destination_port_ranges     = ["22","3389","80","8080","443"]
        source_address_prefix      = "0.0.0.0/0"
        destination_address_prefix = "*"
    }    
    security_rule {
        name                       = "GENERIC-RULE-FOR-PREVENT-INTERNET-ACCESS-IN"
        priority                   = 1012
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        #destination_port_ranges     = "["22","3389","80","8080"]" 
        #destination_port_ranges     = ["22","3389","80","8080","443"]
        source_address_prefix      = "0.0.0.0/0"
        destination_address_prefix = "*"
    }
}

# Connect the security group to the network interface for VMSS
resource "azurerm_subnet_network_security_group_association" "new_terraform_subnet_web-asso-nsg" {
  subnet_id                 = azurerm_subnet.new_terraform_subnet_web.id
  network_security_group_id = azurerm_network_security_group.generic-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "new_terraform_subnet_web_internet_prevent-asso-nsg" {
  subnet_id                 = azurerm_subnet.new_terraform_subnet_web.id
  network_security_group_id = azurerm_network_security_group.generic-nsg-internet.id
}
# Connect the security group to the network interface for WAF 2 
resource "azurerm_subnet_network_security_group_association" "new_terraform_subnet_frontwaf_internet_prevent-asso-nsg" {
  depends_on = [azurerm_application_gateway.waf-vmss-vdc-001]
  subnet_id                 = azurerm_subnet.new_terraform_subnet_frontwaf.id
  network_security_group_id = azurerm_network_security_group.generic-nsg-internet.id
}


# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.existing_terraform_rg.name
    }
    byte_length = 8
}
