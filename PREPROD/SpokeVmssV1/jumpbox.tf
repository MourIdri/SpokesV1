


# Create public IPs
resource "azurerm_public_ip" "spk1-jbx-puip" {
    name                         = "spk1-jbx-puip"
    location                     = "westeurope"
    resource_group_name          = azurerm_resource_group.existing_terraform_rg.name
    domain_name_label            = "lbvmssskp1jbmt"
    allocation_method            = "Dynamic"
}



# Create network interface
resource "azurerm_network_interface" "spk1-jbx-nic" {
    name                      = "spk1-jbx-nic"
    location                  = "westeurope"
    resource_group_name       = azurerm_resource_group.existing_terraform_rg.name
    ip_configuration {
        name                          = "spk1-jbx-nic-conf"
        subnet_id                     = azurerm_subnet.spk1-jbx-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.spk1-jbx-puip.id
    }
}

resource "azurerm_virtual_machine" "spk1-jbx-vm" {
  name                  = "spk1-jbx-vm"
  location              = "westeurope" 
  resource_group_name   = azurerm_resource_group.existing_terraform_rg.name
  network_interface_ids = ["${azurerm_network_interface.spk1-jbx-nic.id}"]
  vm_size               = "Standard_D2s_v3"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       =  "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "spk1-jbx-vm-mtwin-disk-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "spk1-jbx-vm"
    admin_username = "demouser"
    admin_password = "M0nP@ssw0rd!" 
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }

}

