############################
# Authentication variables #
############################
# Add you service endpoint access strings

#variable "azure-client-app-id" {
#    type        = any
#    description="The Client ID of the Service Principal."
#}
#variable "azure-subscription-id" {
#    type        = any
#    description="The ID of the Azure Subscription in which to run the Acceptance Tests."
#}
#variable "azure-client-secret-password" {
#    type        = any
#    description="The Client Secret associated with the Service Principal."
#}
#variable "azure-tenant-id" {
#    type        = any
#    description="The Tenant ID to use."
#}
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
############################
# GENERAL NETWRK VARIABLES #
############################
variable "current-vnet-space" {
  description = "defining the vnetspace using a variable"
  type = any
}
variable "privatedmzin-root-name" {
  description = "defining the privatedmzin  using a variable"
  type = any
}
variable "subnet-privatedmzin" {
  description = "defining the subnet space for privatedmzin  using a variable"
  type = any
}
variable "nsg-privatedmzin" {
  description = "defining the nsg port range space for privatedmzin  using a variable"
  type = any
}
variable "privatedmzoutlan-root-name" {
  description = "defining the privatedmzoutlan  using a variable"
  type = any
}
variable "subnet-privatedmzoutlan" {
  description = "defining the subnet space for privatedmzoutlan  using a variable"
  type = any
}
variable "nsg-privatedmzoutlan" {
  description = "defining the nsg port range space for privatedmzoutlan  using a variable"
  type = any
}
variable "mt-area-dc-dns-private-ip-address" {
  description = "IP Address for private DC DNS "
  type = any
}
variable "security-appliance-dmz-private-ip-address-out" {
  description = "IP Address for OUT private sec appliance "
  type = any
}
variable "security-appliance-dmz-private-ip-address-in" {
  description = "IP Address for INT private sec appliance "
  type = any
}
variable "mt-root-name" {
  description = "root name for mgmt windows  "
  type = any
}
variable "subnet-mt" {
  description = "root name for mgmt windows  "
  type = any
}
variable "nsg-mt-1" {
  description = "root name for mgmt windows  "
  type = any
}
variable "nsg-mt-2" {
  description = "root name for mgmt windows  "
  type = any
}
variable "nsg-mt-3" {
  description = "root name for mgmt windows  "
  type = any
}
variable "mt-vm-private-ip-address" {
  description = "root name for mgmt windows  "
  type = any
}
variable "mtl-vm-private-ip-address" {
  description = "root name for mgmt windows  "
  type = any
}
variable "publicdmzin-root-name" {
  description = "root name for mgmt windows  "
  type = any
}
variable "subnet-publicdmzin" {
  description = "root name for mgmt windows  "
  type = any
}
variable "nsg-publicdmzin-1" {
  description = "root name for mgmt windows  "
  type = any
}
variable "nsg-publicdmzin-2" {
  description = "root name for mgmt windows  "
  type = any
}
variable "waf-vm-private-public-ip-address" {
  description = "root name for mgmt windows  "
  type = any
}

variable "GatewaySubnet-root-name" {
  description = "root name for mgmt windows  "
  type = any
}
variable "subnet-GatewaySubnet" {
  description = "root name for mgmt windows  "
  type = any
}
variable "nsg-GatewaySubnet-1" {
  description = "root name for mgmt windows  "
  type = any
}
variable "nsg-GatewaySubnet-2" {
  description = "root name for mgmt windows  "
  type = any
}
variable "nsg-GatewaySubnet-3" {
  description = "root name for mgmt windows  "
  type = any
}
variable "nsg-GatewaySubnet-4" {
  description = "root name for mgmt windows  "
  type = any
}
variable "iprange-onprem-vpn" {
  description = "root name for mgmt windows  "
  type = any
}
variable "ipaddress-routeur-onprem-1-azuredevops" {
  description = "root name for mgmt windows  "
  type = any
}


#LOGIN PASSWORDS
variable "genericusername" {
  description = "Username for Virtual Machines"
  default     = "demouser"
}
variable "genericpassword" {
  description = "Password for Virtual Machines"
  default     = "M0nP@ssw0rd!"
}
variable "current-vm-default-username-main" {
  description = "Username for Virtual Machines"
  type = any 
}
variable "current-vm-default-pass-main" {
  description = "Password for Virtual Machines"
  type = any 
}



#INSTANCE CATALOGUE 
variable "vmsize_small_1_2" {
  description = "Size of the VMs"
  default     = "Standard_F1s"
}
variable "vmsize_small_1_4" {
  description = "Size of the VMs"
  default     = "Standard_DS1_v2"
}
variable "vmsize_medium_2_4" {
  description = "Size of the VMs"
  default     = "Standard_F2s_v2"
}
variable "vmsize_medium_2_8" {
  description = "Size of the VMs"
  default     = "Standard_D2s_v3"
}
variable "vmsize_high_4_8" {
  description = "Size of the VMs"
  default     = "Standard_F4s_v2"
}
variable "vmsize_high_4_16" {
  description = "Size of the VMs"
  default     = "Standard_D4s_v3"
}
