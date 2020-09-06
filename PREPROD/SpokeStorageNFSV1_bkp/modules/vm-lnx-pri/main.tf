# Create public IPs
resource "azurerm_public_ip" "mtl-nic-private-dmz-in-puip" {
    depends_on = [var.mtl_depend_on]
    name                         = "${var.current-name-convention-core-module}-mtl1-ub16-nicinpuip"
    location                     = "${var.preferred-location-module}" 
    resource_group_name          = "${var.current-name-convention-core-module}-rg"
    domain_name_label            = "${var.current-name-convention-core-public-module}mtl1"
    allocation_method            = "Static"
    tags = "${var.tags-mtl-lnx-module}"
}
resource "azurerm_network_interface" "mtl-nic-private-dmz-in" {
  depends_on = [var.mtl_depend_on]
  name                 = "${var.current-name-convention-core-module}-mtl-ub16-nicin"
  location            = "${var.preferred-location-module}" 
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  enable_ip_forwarding = true
  tags = "${var.tags-mtl-lnx-module}"
  ip_configuration {
    name                          = "${var.current-name-convention-core-module}-mtl-ub16-nicinconfig"
    subnet_id                     = "${var.subnet_in_id_module}" 
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.ip-in-mtl-module}" 
    public_ip_address_id          = "${azurerm_public_ip.mtl-nic-private-dmz-in-puip.id}"
  }
}

resource "azurerm_virtual_machine" "mtl-ub16" {
  name                 = "${var.current-name-convention-core-module}-mtl-ub16"
  location            = "${var.preferred-location-module}" 
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  network_interface_ids = ["${azurerm_network_interface.mtl-nic-private-dmz-in.id}"]
  vm_size               = "${var.mtl-size}"
  tags = "${var.tags-mtl-lnx-module}"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.current-name-convention-core-module}-mtl-ub16-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.current-name-convention-core-module}-mtl-ub16"
    admin_username = "${var.mtl-login}"
    admin_password = "${var.mtl-passwd}" 
  }
  boot_diagnostics {
        enabled     = "true"
        storage_uri = "${var.stor-log-repo}"
    }  
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine_extension" "mt1_custom_script" {
  name                 = "${var.current-name-convention-core-module}-mtl-ub16-customscript-admin"
  virtual_machine_id   = azurerm_virtual_machine.mtl-ub16.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  settings = <<SETTINGS
    {
        "commandToExecute": "sudo apt-add-repository ppa:ansible/ansible -y && sudo apt update -y && sudo apt-get install -y libssl-dev libffi-dev python-dev python-pip  && sudo pip install ansible[azure] pywinrm && curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && sudo apt-get install -y ansible"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "mtl_oms_mma" {
 depends_on = [azurerm_virtual_machine_extension.mt1_custom_script]
 name                 = "${var.current-name-convention-core-module}-mtl-ub16-OMSExtension"
 #location                      = "${var.vm_location}"
 #resource_group_name           = "${var.resource_group_name}"
 virtual_machine_id = "${azurerm_virtual_machine.mtl-ub16.id}"
 publisher                     = "Microsoft.EnterpriseCloud.Monitoring"
 type                          = "OmsAgentForLinux"
 type_handler_version          = "1.6"
 auto_upgrade_minor_version    = "true"

  settings = <<SETTINGS
        {
          "workspaceId": "${var.stor-log-ws-crd-1}"
        }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${var.stor-log-ws-crd-2}"
        }
PROTECTED_SETTINGS
}



resource "azurerm_virtual_machine_extension" "mtl_diag_setting" {
depends_on = [azurerm_virtual_machine_extension.mt1_custom_script]
 name                 = "${var.current-name-convention-core-module}-mtl-ub16-LinuxDiagnostics"
 virtual_machine_id = "${azurerm_virtual_machine.mtl-ub16.id}"
 publisher                     = "Microsoft.Azure.Diagnostics"
 type                          = "LinuxDiagnostic"
 type_handler_version          = "3.0"
 auto_upgrade_minor_version    = "true"

  settings = <<SETTINGS

        {
        "StorageAccount": "${var.stor-log-repo-name}",
        "ladCfg": {
            "diagnosticMonitorConfiguration": {
            "eventVolume": "Medium", 
            "metrics": {
                "metricAggregation": [
                {
                    "scheduledTransferPeriod": "PT1H"
                }, 
                {
                    "scheduledTransferPeriod": "PT1M"
                }
                ], 
                "resourceId": "${azurerm_virtual_machine.mtl-ub16.id}"
            }, 
            "performanceCounters": {
                "performanceCounterConfiguration": [
                {
                    "annotation": [
                    {
                        "displayName": "Disk read guest OS", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "readbytespersecond", 
                    "counterSpecifier": "/builtin/disk/readbytespersecond", 
                    "type": "builtin", 
                    "unit": "BytesPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Disk writes", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "writespersecond", 
                    "counterSpecifier": "/builtin/disk/writespersecond", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Disk transfer time", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "averagetransfertime", 
                    "counterSpecifier": "/builtin/disk/averagetransfertime", 
                    "type": "builtin", 
                    "unit": "Seconds"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Disk transfers", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "transferspersecond", 
                    "counterSpecifier": "/builtin/disk/transferspersecond", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Disk write guest OS", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "writebytespersecond", 
                    "counterSpecifier": "/builtin/disk/writebytespersecond", 
                    "type": "builtin", 
                    "unit": "BytesPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Disk read time", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "averagereadtime", 
                    "counterSpecifier": "/builtin/disk/averagereadtime", 
                    "type": "builtin", 
                    "unit": "Seconds"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Disk write time", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "averagewritetime", 
                    "counterSpecifier": "/builtin/disk/averagewritetime", 
                    "type": "builtin", 
                    "unit": "Seconds"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Disk total bytes", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "bytespersecond", 
                    "counterSpecifier": "/builtin/disk/bytespersecond", 
                    "type": "builtin", 
                    "unit": "BytesPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Disk reads", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "readspersecond", 
                    "counterSpecifier": "/builtin/disk/readspersecond", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Disk queue length", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "disk", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "averagediskqueuelength", 
                    "counterSpecifier": "/builtin/disk/averagediskqueuelength", 
                    "type": "builtin", 
                    "unit": "Count"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Network in guest OS", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "network", 
                    "counter": "bytesreceived", 
                    "counterSpecifier": "/builtin/network/bytesreceived", 
                    "type": "builtin", 
                    "unit": "Bytes"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Network total bytes", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "network", 
                    "counter": "bytestotal", 
                    "counterSpecifier": "/builtin/network/bytestotal", 
                    "type": "builtin", 
                    "unit": "Bytes"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Network out guest OS", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "network", 
                    "counter": "bytestransmitted", 
                    "counterSpecifier": "/builtin/network/bytestransmitted", 
                    "type": "builtin", 
                    "unit": "Bytes"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Network collisions", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "network", 
                    "counter": "totalcollisions", 
                    "counterSpecifier": "/builtin/network/totalcollisions", 
                    "type": "builtin", 
                    "unit": "Count"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Packets received errors", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "network", 
                    "counter": "totalrxerrors", 
                    "counterSpecifier": "/builtin/network/totalrxerrors", 
                    "type": "builtin", 
                    "unit": "Count"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Packets sent", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "network", 
                    "counter": "packetstransmitted", 
                    "counterSpecifier": "/builtin/network/packetstransmitted", 
                    "type": "builtin", 
                    "unit": "Count"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Packets received", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "network", 
                    "counter": "packetsreceived", 
                    "counterSpecifier": "/builtin/network/packetsreceived", 
                    "type": "builtin", 
                    "unit": "Count"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Packets sent errors", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "network", 
                    "counter": "totaltxerrors", 
                    "counterSpecifier": "/builtin/network/totaltxerrors", 
                    "type": "builtin", 
                    "unit": "Count"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem transfers/sec", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "transferspersecond", 
                    "counterSpecifier": "/builtin/filesystem/transferspersecond", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem % free space", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentfreespace", 
                    "counterSpecifier": "/builtin/filesystem/percentfreespace", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem % used space", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentusedspace", 
                    "counterSpecifier": "/builtin/filesystem/percentusedspace", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem used space", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "usedspace", 
                    "counterSpecifier": "/builtin/filesystem/usedspace", 
                    "type": "builtin", 
                    "unit": "Bytes"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem read bytes/sec", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "bytesreadpersecond", 
                    "counterSpecifier": "/builtin/filesystem/bytesreadpersecond", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem free space", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "freespace", 
                    "counterSpecifier": "/builtin/filesystem/freespace", 
                    "type": "builtin", 
                    "unit": "Bytes"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem % free inodes", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentfreeinodes", 
                    "counterSpecifier": "/builtin/filesystem/percentfreeinodes", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem bytes/sec", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "bytespersecond", 
                    "counterSpecifier": "/builtin/filesystem/bytespersecond", 
                    "type": "builtin", 
                    "unit": "BytesPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem reads/sec", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "readspersecond", 
                    "counterSpecifier": "/builtin/filesystem/readspersecond", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem write bytes/sec", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "byteswrittenpersecond", 
                    "counterSpecifier": "/builtin/filesystem/byteswrittenpersecond", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem writes/sec", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "writespersecond", 
                    "counterSpecifier": "/builtin/filesystem/writespersecond", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Filesystem % used inodes", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "filesystem", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentusedinodes", 
                    "counterSpecifier": "/builtin/filesystem/percentusedinodes", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "CPU IO wait time", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "processor", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentiowaittime", 
                    "counterSpecifier": "/builtin/processor/percentiowaittime", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "CPU user time", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "processor", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentusertime", 
                    "counterSpecifier": "/builtin/processor/percentusertime", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "CPU nice time", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "processor", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentnicetime", 
                    "counterSpecifier": "/builtin/processor/percentnicetime", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "CPU percentage guest OS", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "processor", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentprocessortime", 
                    "counterSpecifier": "/builtin/processor/percentprocessortime", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "CPU interrupt time", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "processor", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentinterrupttime", 
                    "counterSpecifier": "/builtin/processor/percentinterrupttime", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "CPU idle time", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "processor", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentidletime", 
                    "counterSpecifier": "/builtin/processor/percentidletime", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "CPU privileged time", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "processor", 
                    "condition": "IsAggregate=TRUE", 
                    "counter": "percentprivilegedtime", 
                    "counterSpecifier": "/builtin/processor/percentprivilegedtime", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Memory available", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "availablememory", 
                    "counterSpecifier": "/builtin/memory/availablememory", 
                    "type": "builtin", 
                    "unit": "Bytes"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Swap percent used", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "percentusedswap", 
                    "counterSpecifier": "/builtin/memory/percentusedswap", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Memory used", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "usedmemory", 
                    "counterSpecifier": "/builtin/memory/usedmemory", 
                    "type": "builtin", 
                    "unit": "Bytes"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Page reads", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "pagesreadpersec", 
                    "counterSpecifier": "/builtin/memory/pagesreadpersec", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Swap available", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "availableswap", 
                    "counterSpecifier": "/builtin/memory/availableswap", 
                    "type": "builtin", 
                    "unit": "Bytes"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Swap percent available", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "percentavailableswap", 
                    "counterSpecifier": "/builtin/memory/percentavailableswap", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Mem. percent available", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "percentavailablememory", 
                    "counterSpecifier": "/builtin/memory/percentavailablememory", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Pages", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "pagespersec", 
                    "counterSpecifier": "/builtin/memory/pagespersec", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Swap used", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "usedswap", 
                    "counterSpecifier": "/builtin/memory/usedswap", 
                    "type": "builtin", 
                    "unit": "Bytes"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Memory percentage", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "percentusedmemory", 
                    "counterSpecifier": "/builtin/memory/percentusedmemory", 
                    "type": "builtin", 
                    "unit": "Percent"
                }, 
                {
                    "annotation": [
                    {
                        "displayName": "Page writes", 
                        "locale": "en-us"
                    }
                    ], 
                    "class": "memory", 
                    "counter": "pageswrittenpersec", 
                    "counterSpecifier": "/builtin/memory/pageswrittenpersec", 
                    "type": "builtin", 
                    "unit": "CountPerSecond"
                }
                ]
            }, 
            "syslogEvents": {
                "syslogEventConfiguration": {
                "LOG_AUTH": "LOG_DEBUG", 
                "LOG_AUTHPRIV": "LOG_DEBUG", 
                "LOG_CRON": "LOG_DEBUG", 
                "LOG_DAEMON": "LOG_DEBUG", 
                "LOG_FTP": "LOG_DEBUG", 
                "LOG_KERN": "LOG_DEBUG", 
                "LOG_LOCAL0": "LOG_DEBUG", 
                "LOG_LOCAL1": "LOG_DEBUG", 
                "LOG_LOCAL2": "LOG_DEBUG", 
                "LOG_LOCAL3": "LOG_DEBUG", 
                "LOG_LOCAL4": "LOG_DEBUG", 
                "LOG_LOCAL5": "LOG_DEBUG", 
                "LOG_LOCAL6": "LOG_DEBUG", 
                "LOG_LOCAL7": "LOG_DEBUG", 
                "LOG_LPR": "LOG_DEBUG", 
                "LOG_MAIL": "LOG_DEBUG", 
                "LOG_NEWS": "LOG_DEBUG", 
                "LOG_SYSLOG": "LOG_DEBUG", 
                "LOG_USER": "LOG_DEBUG", 
                "LOG_UUCP": "LOG_DEBUG"
                }
            }
            }, 
            "sampleRateInSeconds": 15
        }
        }


SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
{
  "storageAccountName": "${var.stor-log-repo-name}",
  "storageAccountSasToken": "${var.stor-log-repo-sas}",
  "sinksConfig": 
      {
        "sink": [
          {
              "name": "SyslogJsonBlob",
              "type": "JsonBlob"
          },
          {
              "name": "LinuxCpuJsonBlob",
              "type": "JsonBlob"
          }
        ]
  }
}
                                                                                

PROTECTED_SETTINGS
}