module "fw-mgmt" {
  source    = "./fw-mgmt"
  ip_groups = module.ipg_ip_groups.ip_groups
}

module "mapper" {
  source    = "./mapper"
  workloads = module.fw-mgmt.workloads
}

module "rcg_workloads" {
  source = "git::https://gitlab.lu.ad.dom/slv-cloud/infrastruktur/terraform-azurerm-firewall-rule-collection-group.git?ref=v1.0.1"
  firewall_rule_collection_groups = [
    for wl in module.mapper.result : merge(wl, {
      firewall_policy_id = data.terraform_remote_state.fw-mgmt.outputs.firewall_policy_id
    })
  ]
}
