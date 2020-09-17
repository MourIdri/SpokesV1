############################
# GENERAL TENANT VARIABLES #
############################
variable "preferred-location-module" {
  description = "Location of the network"
  #default     = "westeurope"
}
variable "current-name-convention-core-submodule" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  #default     = "crpc-prod-shar-hub"
}
variable "rg_depends_on" {
  type    = any
  default = null
}
variable "tags-rg-module" {
  type    = any
  default = null
}

variable "subnet-ip-range-convention-core-submodule" {
  type    = any
  default = null
}
variable "subnet-subroot-name-submodule" {
  type    = any
  default = null
}
variable "preferred-location-submodule" {
  type    = any
  default = null
}
variable "subnet_depend_on_submodule" {
  type    = any
  default = null
}
variable "subnet-mgmt-port-range-submodule" {
  type    = any
  default = null
}
