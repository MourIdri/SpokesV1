############################
# GENERAL TENANT VARIABLES #
############################
variable "preferred-location-main" {
  description = "Location of the network"
  type = any
}
variable "second-location-main" {
  description = "Location of the network"
  type = any
}
variable "current-name-convention-core-main" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  type = any
}
variable "current-name-convention-core-public-main" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  type = any
}

variable "current-name-convention-core-public-hub-main" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  type = any
}
variable "current-name-convention-core-hub-main" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  type = any
}



############################
# GENERAL NETWRK VARIABLES #
############################
variable "current-vnet-space" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "current-vnet-name" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "current-workload-core" {
  description = "defining the vnetspace using a variable"
  type = any
}
############################
# GENERAL SUBNET VARIABLES #
############################
variable "current-subnet-root-name" {
  description = "defining the vnetspace using a variable"
  type = any
}

############################
# GENERAL ROUTES VARIABLES #
############################
variable "current-route-table-core-name" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "current-route-table-core-name-source" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "current-route-table-core-name-destination" {
  description = "defining the vnetspace using a variable"
  type = any
}
####################################
# GENERAL SHARED PASSWOD VARIABLES #
####################################
variable "current-vm-default-pass-main" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "current-vm-default-username-main" {
  description = "defining the vnetspace using a variable"
  type = any
}
####################################
# GENERAL SHARED STORAGE VARIABLES #
####################################
variable "spoke-storage-root-name" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "spoke-storage-subnet-range" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "spoke-storage-nsg-port-range" {
  description = "defining the vnetspace using a variable"
  type = any
}


variable "spoke-aks-root-name" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "spoke-aks-subnet-range-1" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "spoke-aks-subnet-range-2" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "spoke-aks-2-root-name" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "spoke-aks-nsg-port-range-1" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "spoke-aks-nsg-port-range-2" {
  description = "defining the vnetspace using a variable"
  type = any
}



variable "nva-ip-out-to-spoke-main" {
  description = "defining the vnetspace using a variable"
  type = any
}