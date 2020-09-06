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
  description = "RG and other Generic"
  type = any
}
variable "current-name-convention-core-public-main" {
  description = "Public generic "
  type = any
}


############################
# GENERAL NETWRK VARIABLES #
############################
variable "current-name-convention-core-network-main" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "current-name-convention-core-public-network-main" {
  description = "defining the vnetspace using a variable"
  type = any
}

####################################
# GENERAL SUBNET & SPOKE VARIABLES #
####################################
variable "current-name-convention-core-storage-main" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "current-name-convention-core-public-storage-main" {
  description = "defining the vnetspace using a variable"
  type = any
}

variable "spoke-storage-root-name" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "spoke-storage-root-range" {
  description = "defining the vnetspace using a variable"
  type = any
}

variable "spoke-storage-nsg-port-range" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "nva-ip-out-to-spoke-main" {
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
