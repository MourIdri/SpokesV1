resource "azurerm_windows_virtual_machine_scale_set" "new_terraform_vmss_web" {
  depends_on = [azurerm_application_gateway.waf-vmss-vdc-001]
  name                = "vmss-001"
  resource_group_name =  azurerm_resource_group.existing_terraform_rg.name
  location            =  azurerm_resource_group.existing_terraform_rg.location
  sku                 = "Standard_F2"
  instances           = 3
  admin_password      = "P@55w0rd1234!"
  admin_username      = "adminuser"
  #zone_balance = true
  #zones = [1]
  upgrade_mode = "Manual"
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  network_interface {
    name    = "vmss-001-nic-1"
    primary = true
    ip_configuration {
      name      = "vmss-001-nic-1-Configuration"
      primary   = true
      subnet_id = azurerm_subnet.new_terraform_subnet_web.id
      application_gateway_backend_address_pool_ids = "${azurerm_application_gateway.waf-vmss-vdc-001.backend_address_pool[*].id}"
    }
  }
}
