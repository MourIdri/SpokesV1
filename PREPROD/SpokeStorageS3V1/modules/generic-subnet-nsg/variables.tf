
############################
# GENERAL TENANT VARIABLES #
############################
variable "current-name-convention-core-module" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  #default     = "crpc-prod-shar-hub"
}
variable "current-name-convention-core-public-module" {
  type    = any
  default = null
}
variable "preferred-location-module" {
  type    = any
  default = null
}
variable "root-name-subnet-module" {
  type    = any
  default = null
}
variable "iprange-subnet-module" {
  type    = any
  default = null
}
variable "portrange-subnet-module" {
  type    = any
  default = null
}
variable "subnet_depend_on_module" {
  type    = any
  default = null
}
variable "nva-ip-out-to-spoke-module" {
  type    = any
  default = null
}
