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


resource "azurerm_resource_group" "resource_group_spoke" {
  name                     = "${var.current-name-convention-core-main}-rg"
  location                 = "${var.preferred-location-main}"
}


data "azurerm_subnet" "subnet-spoke-storage" {
  name                = "${var.current-name-convention-core-network-main}-subnet-${var.spoke-storage-root-name}"
  virtual_network_name = "${var.current-name-convention-core-network-main}-vnet"
  resource_group_name = "${var.current-name-convention-core-network-main}-rg"
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
  stoc_depend_on_module = [azurerm_resource_group.resource_group_spoke ]
  logacc_depend_on_module = [azurerm_resource_group.resource_group_spoke]
}

#CI Validated so far 
module "vm-nfs-sto-1" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/vm-lnx-pri"
  subnet_in_id_module = data.azurerm_subnet.subnet-spoke-storage.id
  ip-in-mtl-module = "${var.vm-nfs-sto-1-private-ip-address}" 
  mtl-size ="${var.vmsize_small_1_2}"
  mtl-login = "${var.current-vm-default-username-main}"
  mtl-passwd = "${var.current-vm-default-pass-main}"
  stor-log-repo = "${module.logging.hub-corpc-sto-acc-log-endpoint}"
  stor-log-repo-name = "${module.logging.hub-corpc-sto-acc-log-name}"
  stor-log-repo-sas = "${module.logging.hub-corpc-sto-acc-log-sas-url-string}"
  stor-log-ws-crd-1 = "${module.logging.hub-corpc-log-ana-rep-primary-workspace-id}"
  stor-log-ws-crd-2 = "${module.logging.hub-corpc-log-ana-rep-primary-key}"  
  mtl_depend_on = [azurerm_resource_group.resource_group_spoke, module.logging ]
}
