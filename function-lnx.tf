module "func_linux" {
  count                                  = true ? 1 : 0
  source                                 = "./modules/az-function-lnx"
  location                               = local.location
  resource_group_name                    = local.rg_name
  func_name                              = local.func_name_lnx
  func_app_storage_name                  = local.func_storage_name_lnx
  pep_name                               = "pep-func-linux"
  private_service_name                   = "psc-func-linux"
  log_analytics_ws_id                    = azurerm_log_analytics_workspace.log_analytics_ws.id
  azurerm_app_service_id                 = azurerm_service_plan.asp_funclnx.id
  pep_subnet_id                          = azurerm_subnet.private_endpoint.id
  swift_subnet_id                        = azurerm_subnet.subnet_funclnx.id
  func_dns_id                            = azurerm_private_dns_zone.privatedns_azurewebsites.id
  file_dns_id                            = azurerm_private_dns_zone.privatedns_file.id
  blob_dns_id                            = azurerm_private_dns_zone.privatedns_blob.id
  queue_dns_id                           = azurerm_private_dns_zone.privatedns_queue.id
  table_dns_id                           = azurerm_private_dns_zone.privatedns_table.id
  application_insights_connection_string = azurerm_application_insights.app_insight.connection_string
  application_insights_key               = azurerm_application_insights.app_insight.instrumentation_key
  python_version                         = 3.9
  storage_account_networksetting         = "Deny"
  depends_on = [
    azurerm_resource_group.rg
  ]
}
