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


#resource "azurerm_resource_group" "resource_group_spoke_storage" {
#  name                     = "${var.current-name-convention-core-main}-rg"
#  location                 = "${var.preferred-location-main}"
#}

#resource "azurerm_storage_account" "mots2" {
#  name                     = "${var.current-name-convention-core-public-main}mots2"
#  resource_group_name      = azurerm_resource_group.resource_group_spoke_storage.name
#  location                 = azurerm_resource_group.resource_group_spoke_storage.location
#  account_tier             = "Standard"
#  account_replication_type = "LRS"
#}

module "rgsa" {
  source               = "./modules/rg"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"
}

resource "azurerm_storage_account" "mots2" {
  name                     = "${var.current-name-convention-core-public-main}mots2"
  resource_group_name      = "${module.rgsa.resource_group_name_spoke-name}"
  location                 = "${var.preferred-location-main}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "mots1" {
  name                     = "${var.current-name-convention-core-public-main}mots1"
  resource_group_name      = "${module.rgsa.resource_group_name_spoke-name}"
  location                 = "${var.preferred-location-main}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#CI Validated so far 
module "logging" {
  source               = "./modules/logging"
  current-vm-default-pass-module = "${var.current-vm-default-pass-main}"
  current-vm-default-username-module = "${var.current-vm-default-username-main}"
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"
  current-az-sp-object-id-module = data.azurerm_client_config.current.object_id
  current-az-sp-tenant-id-module = data.azurerm_client_config.current.tenant_id
  stoc_depend_on_module = [module.rgsa ]
  logacc_depend_on_module = [module.rgsa ]
}



#dat#a "azurerm_subnet" "subnet-spoke-storage" {
#  n#ame                = "${var.current-name-convention-core-network-main}-subnet-${var.spoke-storage-root-name}"
#  v#irtual_network_name = "${var.current-name-convention-core-network-main}-vnet"
#  resource_group_name = "${var.current-name-convention-core-network-main}-rg"
#}

#CI #Validated so far test
#CI #Validated so far test
#mod#ule "vm-nfs-sto-1" {
#  c#urrent-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
#  c#urrent-name-convention-core-module  = "${var.current-name-convention-core-main}"
#  p#referred-location-module = "${var.preferred-location-main}"  
#  s#ource               = "./modules/vm-lnx-pri"
#  s#ubnet_in_id_module = data.azurerm_subnet.subnet-spoke-storage.id
#  i#p-in-mtl-module = "${var.vm-nfs-sto-1-private-ip-address}" 
#  m#tl-size ="${var.vmsize_small_1_2}"
#  m#tl-login = "${var.current-vm-default-username-main}"
#  m#tl-passwd = "${var.current-vm-default-pass-main}"
#  s#tor-log-repo = "${module.logging.hub-corpc-sto-acc-log-endpoint}"
#  s#tor-log-repo-name = "${module.logging.hub-corpc-sto-acc-log-name}"
#  s#tor-log-repo-sas = "${module.logging.hub-corpc-sto-acc-log-sas-url-string}"
#  s#tor-log-ws-crd-1 = "${module.logging.hub-corpc-log-ana-rep-primary-workspace-id}"
#  s#tor-log-ws-crd-2 = "${module.logging.hub-corpc-log-ana-rep-primary-key}"  
#  mtl_depend_on = [azurerm_resource_group.resource_group_spoke, module.logging ]
#}
