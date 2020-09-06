############################
# GENERAL TENANT VARIABLES #
############################

variable "preferred-location-module" {
  description = "Location of the network"
  #default     = "westeurope"
}

variable "current-name-convention-core-module" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  #default     = "crpc-prod-shar-hub"
}

variable "current-name-convention-core-public-module" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  #default     = "crcprdshrhub"
}

variable "subnet_in_id_module" {
  type    = any
  default = null
}
variable "ip-in-mtl-module" {
  type    = any
  default = null
}
variable "mtl-passwd" {
  type    = any
  default = null
}
variable "mtl-login" {
  type    = any
  default = null
}
variable "mtl_depend_on" {
  type    = any
  default = null
}
variable "mtl-size" {
  type    = any
  default = null
}
variable "stor-log-repo" {
  type    = any
  default = null
}
variable "stor-log-repo-name" {
  type    = any
  default = null
}
variable "stor-log-repo-sas" {
  type    = any
  default = null
}
variable "tags-mtl-lnx-module" {
  type    = any
  default = null
}

variable "stor-log-ws-crd-1" {
  type    = any
  default = null
}
variable "stor-log-ws-crd-2" {
  type    = any
  default = null
}
