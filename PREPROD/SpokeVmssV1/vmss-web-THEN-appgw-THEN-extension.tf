

resource "azurerm_virtual_machine_scale_set_extension" "new_terraform_vmss_web_ext_1" {
  name                         = "new_terraform_vmss_web_ext_1"
  virtual_machine_scale_set_id = azurerm_windows_virtual_machine_scale_set.new_terraform_vmss_web.id
    publisher = "Microsoft.Compute"
    type = "CustomScriptExtension"
    type_handler_version = "1.9"
    settings = <<SETTINGS
        {
            "fileUris": ["https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis-v2.ps1"]
        }
            SETTINGS
    protected_settings = <<PROTECTED_SETTINGS
        { 
            "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File automate-iis-v2.ps1"
        }
            PROTECTED_SETTINGS
}
#https://rgcloudmouradgeneraleuro.blob.core.windows.net/public/automate-iis-v2.ps1
#https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis-v2.ps1 