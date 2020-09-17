############################
# GENERAL TENANT VARIABLES #
############################

variable "preferred-location-module" {
  description = "Location of the network"
  default     = "westeurope"
}
variable "current-name-convention-core-module" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  #default     = "crpc-prod-shar-hub"
}
variable "current-name-convention-core-public-module" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  #default     = "crcprdshrhub"
}
variable "tags-vnet-module" {
  type    = any
  default = null
}
variable "vnet_depend_on_module" {
  type    = any
  default = null
}
variable "ip-range-module" {
  description = "IP range used to delimite the HUB"
  type    = any
  default = null
}
variable "subnet-vpn-gw-ip-range-module" {
  description = "IP range used to delimite the HUB"
  type    = any
  default = null
}
variable "subnet-mgmt-ip-range-module" {
  description = "IP range used to delimite the HUB"
  type    = any
  default = null
}

variable "subnet-mgmt-root-name-module" {
  description = "IP range used to delimite the HUB"
  type    = any
  default = null
}

variable "subnet-ip-range-convention-core-module" {
  description = "IP range used to delimite the HUB"
  type    = any
  default = null
}

variable "tags-nsg-module" {
  type    = any
  default = null
}
variable "nsg_depends_on" {
  type    = any
  default = null
}
variable "subnet-mgmt-port-range-module" {
  type    = any
  default = null
}

