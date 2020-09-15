output "resource_group_name_spoke-id" {
  value = "${azurerm_resource_group.resource_group_name.id}"
}
output "resource_group_name_spoke-name" {
  value = "${azurerm_resource_group.resource_group_name.name}"
}