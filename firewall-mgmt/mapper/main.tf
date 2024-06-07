locals {
  result = [
    for wl in var.workloads : {
      tf_id    = wl.name
      name     = wl.name
      priority = wl.priority

      application_rule_collections = [
        for arc in wl.application_rule_collections != null ? wl.application_rule_collections : [] : {
          name     = "${arc.name_config.resource_name}${arc.name_config.endpoint_suffix != null ? "_${arc.name_config.endpoint_suffix}" : ""}"
          priority = arc.priority
          action   = arc.action

          rules = [
            for r in arc.rules : {
              name                  = "${r.name}, ID: ${r.mgmt_table_reference}"
              description           = r.description
              source_addresses      = r.source_addresses
              source_ip_groups      = r.source_ip_groups
              destination_addresses = arc.destination_addresses
              destination_fqdns     = arc.destination_fqdns
              protocols             = arc.protocols
            }
          ]
        }
      ]

      network_rule_collections = [
        for nrc in wl.network_rule_collections != null ? wl.network_rule_collections : [] : {
          name     = "${nrc.name_config.resource_name}${nrc.name_config.endpoint_suffix != null ? "_${nrc.name_config.endpoint_suffix}" : ""}"
          action   = nrc.action
          priority = nrc.priority

          rules = [
            for r in nrc.rules : {
              name                  = "${r.name}, ID: ${r.mgmt_table_reference}"
              description           = r.description
              source_addresses      = r.source_addresses
              source_ip_groups      = r.source_ip_groups
              destination_ports     = nrc.destination_ports
              destination_addresses = nrc.destination_addresses
              destination_ip_groups = nrc.destination_ip_groups
              destination_fqdns     = nrc.destination_fqdns
              protocols             = nrc.protocols
            }
          ]
        }
      ]
    }
  ]
}
