// Todo - Add Custom Role Deletion that denies deletion of the vnet

module "rg_spokes" {
  source = "git::https://github.com/leonardpolz/terraform-modules.git//tf-az-resource-group?ref=v1.0.0"
  resource_groups = [
    merge(
      # Reference from settings.templates.tf
      local.template, {
        tf_id = "spokes"
        name  = "rg-my-custom-name-spokes"
      }
    )
  ]
}

module "vnet_spokes" {
  source = "git::https://github.com/leonardpolz/terraform-modules.git//tf-az-virtual-network?ref=v1.0.6"
  virtual_networks = [
    # Reference from settings.spoke.dns-resolver.tf
    local.dns_resolver_spoke,
    # # Reference from settings.spoke.example-1.tf
    local.example_1_spoke,
    # # Reference from settings.spoke.example-2.tf
    local.example_2_spoke
  ]
}
