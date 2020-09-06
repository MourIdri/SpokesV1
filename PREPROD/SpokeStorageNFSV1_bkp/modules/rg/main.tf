resource "azurerm_resource_group" "resource_group_name" {
  name                     = "${var.current-name-convention-core-module}-rg"
  location                 = "${var.preferred-location-module}"
  tags = "${var.tags-rg-module}"
  depends_on = [var.rg_depends_on]
}

