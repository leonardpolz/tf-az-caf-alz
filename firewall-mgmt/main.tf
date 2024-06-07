module "rules" {
  source = "./rules"
}

module "mapper" {
  source    = "./mapper"
  workloads = module.rules.workloads
}

module "rcg_workloads" {
  source = "git::https://github.com/leonardpolz/terraform-modules//tf-az-firewall-rule-collection-group?ref=v1.0.8"
  firewall_rule_collection_groups = [
    for wl in module.mapper.result : merge(wl, {
      firewall_policy_id = data.terraform_remote_state.connectivity.outputs.firewall_policy_id
    })
  ]
}
