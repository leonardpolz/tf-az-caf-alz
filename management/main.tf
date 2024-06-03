module "alz" {
  source            = "Azure/caf-enterprise-scale/azurerm"
  version           = "5.2.1"
  default_location  = "westeurope"
  disable_telemetry = true

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = "test"

  deploy_core_landing_zones = false

  deploy_management_resources    = true
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = local.settings.subscription_id
}
