output "configuration" {
  description = "Configuration settings for the \"connectivity\" resources."
  value       = local.configure_connectivity_resources
}

output "subscription_id" {
  description = "Subscription ID for the \"connectivity\" resources."
  value       = local.settings.subscription_id
}

output "firewall_policy_id" {
  value = try(module.alz.azurerm_firewall_policy.virtual_wan[element(keys(module.alz.azurerm_firewall_policy.virtual_wan), 0)].id, null)
}
