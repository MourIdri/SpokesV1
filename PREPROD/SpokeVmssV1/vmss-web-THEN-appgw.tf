resource "azurerm_public_ip" "waf-vmss-vdc-001-pip" {
  name                = "waf-vmss-vdc-001-pip"
  resource_group_name = azurerm_resource_group.existing_terraform_rg.name
  location            = azurerm_resource_group.existing_terraform_rg.location
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_subnet.new_terraform_subnet_web.name}-beap"
  frontend_port_name             = "${azurerm_subnet.new_terraform_subnet_web.name}-feport"
  frontend_ip_configuration_name = "${azurerm_subnet.new_terraform_subnet_web.name}-feip"
  frontend_ip_configuration_name_private = "${azurerm_subnet.new_terraform_subnet_web.name}-privateip"
  http_setting_name              = "${azurerm_subnet.new_terraform_subnet_web.name}-be-htst"
  listener_name                  = "${azurerm_subnet.new_terraform_subnet_web.name}-httplstn"
  request_routing_rule_name      = "${azurerm_subnet.new_terraform_subnet_web.name}-rqrt"
  redirect_configuration_name    = "${azurerm_subnet.new_terraform_subnet_web.name}-rdrcfg"
}

resource "azurerm_application_gateway" "waf-vmss-vdc-001" {
  name                = "waf-vmss-vdc-001"
  resource_group_name = azurerm_resource_group.existing_terraform_rg.name
  location            = azurerm_resource_group.existing_terraform_rg.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }
  // Create the IP configurations and frontend port 
  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.new_terraform_subnet_frontwaf.id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.waf-vmss-vdc-001-pip.id
  }

 frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name_private
    subnet_id = azurerm_subnet.new_terraform_subnet_frontwaf.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.100.0.68"
  }

  // Create the backend pool and settings
  backend_address_pool {
    name = local.backend_address_pool_name
  }
  

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  // Create the default listener and rule
  
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
