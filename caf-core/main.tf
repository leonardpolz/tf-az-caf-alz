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
  root_name      = "test"
  library_path   = "${path.module}/lib"

  deploy_core_landing_zones  = true
  archetype_config_overrides = local.archetype_config_overrides
  custom_landing_zones       = local.custom_landing_zones

  deploy_identity_resources    = false
  configure_identity_resources = local.configure_identity_resources
  subscription_id_identity     = ""

  deploy_connectivity_resources    = false
  configure_connectivity_resources = data.terraform_remote_state.connectivity.outputs.configuration
  subscription_id_connectivity     = data.terraform_remote_state.connectivity.outputs.subscription_id

  deploy_management_resources    = false
  configure_management_resources = data.terraform_remote_state.management.outputs.configuration
  subscription_id_management     = data.terraform_remote_state.management.outputs.subscription_id
}
