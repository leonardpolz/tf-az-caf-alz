module "rg_dns_resolver" {
  source = "git::https://github.com/leonardpolz/terraform-modules.git//tf-az-resource-group?ref=v1.0.0"
  resource_groups = [
    merge(
      # Reference from settings.templates.tf
      local.template, {
        tf_id = "dns_resolver"
        name  = "rg-my-custom-name-dns-resolver"
      }
    )
  ]
}

module "private_dns_resolver" {
  source = "git::https://github.com/leonardpolz/terraform-modules.git//tf-az-private-dns-resolver?ref=v1.0.6"
  private_dns_resolvers = [
    merge(
      local.template, {
        tf_id               = "dns_resolver"
        name                = "my-custom-name-dns-resolver"
        resource_group_name = module.rg_dns_resolver.resource_groups["dns_resolver"].name
        virtual_network_id  = data.terraform_remote_state.spokes.outputs.spokes.virtual_networks["dns_resolver"].id

        inbound_endpoints = [
          {
            tf_id = "default"
            name  = "default"


            ip_configurations = {
              tf_id                        = "default"
              name                         = "default"
              subnet_id                    = data.terraform_remote_state.spokes.outputs.spokes.subnets["dns_resolver_dns_resolver"].id
              private_ip_allocation_method = "Static"
              private_ip_address           = "10.101.0.5"
            }
          }
        ]
      }
    )
  ]
}
