Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis-v2.ps1" -OutFile "C:\Users\adminuser\Downloads\automate-iis-v2.ps1"


$customConfig = @{
  "fileUris" = (,"https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis.ps1");
  "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}

# Get information about the scale set
$vmss = Get-AzVmss `
          -ResourceGroupName "rg-ict-spoke1-001" `
          -VMScaleSetName "vmss-001"

# Add the Custom Script Extension to install IIS and configure basic website
$vmss = Add-AzVmssExtension `
  -VirtualMachineScaleSet $vmss `
  -Name "customScript" `
  -Publisher "Microsoft.Compute" `
  -Type "CustomScriptExtension" `
  -TypeHandlerVersion 1.9 `
  -Setting $customConfig

# Update the scale set and apply the Custom Script Extension to the VM instances
Update-AzVmss `
  -ResourceGroupName "rg-ict-spoke1-001" `
  -Name "vmss-001" `
  -VirtualMachineScaleSet $vmss


Test-NetConnection -ComputerName 10.0.1.7 -Port 80