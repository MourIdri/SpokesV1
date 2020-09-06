############################
# GENERAL TENANT VARIABLES #
############################

#variable "ip-range-module" {
#  description = "IP range used to delimite the HUB"
#  type    = any
#  default = null
#}
variable "vnet_peering_depend_on_module" {
  description = "IP range used to delimite the HUB"
  type    = any
  default = null
}
variable "current-name-convention-core-hub-module" {
  description = "IP range used to delimite the HUB"
  type    = any
  default = null
}
variable "current-name-convention-core-public-hub-module" {
  description = "IP range used to delimite the HUB"
  type    = any
  default = null
}
variable "current-name-convention-core-module" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  type = any
}
variable "current-name-convention-core-public-module" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  type = any
}
variable "nt-workload-vnet-id-module" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  type = any
}