## Resource Group##
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
}

##Networking##
#VNET
resource "azurerm_virtual_network" "vnet_prod" {
  name                = "vnet-prod"
  location            = local.location
  resource_group_name = local.rg_name
  address_space       = ["10.100.0.0/19"]
  depends_on = [
    azurerm_resource_group.rg
  ]
}
#Subnet For Private Endpoints
resource "azurerm_subnet" "private_endpoint" {
  name                                           = "snet-private-endpoint"
  resource_group_name                            = local.rg_name
  virtual_network_name                           = azurerm_virtual_network.vnet_prod.name
  address_prefixes                               = ["10.100.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.Web",
  ]
}
#Subnet for Function Windows
resource "azurerm_subnet" "subnet_funcwin" {
  name                 = "snet-func-win"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_prod.name
  address_prefixes     = ["10.100.2.0/24"]

  delegation {
    name = "Microsoft.Web.serverFarms"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
#Subnet for Function Linux
resource "azurerm_subnet" "subnet_funclnx" {
  name                 = "snet-func-lnx"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_prod.name
  address_prefixes     = ["10.100.3.0/24"]

  delegation {
    name = "Microsoft.Web.serverFarms"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

##App Service Plan for functions##
#Linux
resource "azurerm_service_plan" "asp_funclnx" {
  name                = "planx-funclnx-001"
  resource_group_name = local.rg_name
  location            = local.location
  os_type             = "Linux"
  sku_name            = "P1v2"
  depends_on = [
    azurerm_resource_group.rg
  ]
}

#Windows
resource "azurerm_service_plan" "asp_funcwin" {
  name                = "planx-funcwin-001"
  resource_group_name = local.rg_name
  location            = local.location
  os_type             = "Windows"
  sku_name            = "P1v2"
  depends_on = [
    azurerm_resource_group.rg
  ]
}

##Monitoring
#Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics_ws" {
  name                = "law-funcprivate"
  location            = local.location
  resource_group_name = local.rg_name
  #sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.rg
  ]
}

#Application Insight##
resource "azurerm_application_insights" "app_insight" {
  name                = "aai-funcprivate"
  location            = local.location
  resource_group_name = local.rg_name
  application_type    = "other"
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_ws.id
  retention_in_days   = 30
  depends_on = [
    azurerm_resource_group.rg
  ]
}


##DNS##
##Storage Account BLOB DNS
resource "azurerm_private_dns_zone" "privatedns_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.rg_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "linktovnet_blob" {
  name                  = "pdnsz-linkvnet"
  resource_group_name   = local.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_blob.name
  virtual_network_id    = azurerm_virtual_network.vnet_prod.id
}

##Storage Account TABLE DNS
resource "azurerm_private_dns_zone" "privatedns_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = local.rg_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "linktovnet_table" {
  name                  = "pdnsz-linkvnet"
  resource_group_name   = local.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_table.name
  virtual_network_id    = azurerm_virtual_network.vnet_prod.id
}

##Storage Account QUEUE DNS
resource "azurerm_private_dns_zone" "privatedns_queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = local.rg_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "linktovnet_queue" {
  name                  = "pdnsz-linkvnet"
  resource_group_name   = local.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_queue.name
  virtual_network_id    = azurerm_virtual_network.vnet_prod.id
}

##Storage Account FILE DNS
resource "azurerm_private_dns_zone" "privatedns_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = local.rg_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "linktovnet_file" {
  name                  = "pdnsz-linkvnet"
  resource_group_name   = local.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_file.name
  virtual_network_id    = azurerm_virtual_network.vnet_prod.id
}

##Azure WebSites DNS
resource "azurerm_private_dns_zone" "privatedns_azurewebsites" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = local.rg_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "linktovnet_azurewebsites" {
  name                  = "pdnsz-linkvnet"
  resource_group_name   = local.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_azurewebsites.name
  virtual_network_id    = azurerm_virtual_network.vnet_prod.id
}