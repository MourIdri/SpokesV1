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
variable "rg_depends_on" {
  type    = any
  default = null
}
variable "tags-rg-module" {
  type    = any
  default = null
}