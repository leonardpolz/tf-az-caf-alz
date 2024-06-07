variable "workloads" {
  type = set(object({
    name_config = object({
      workload_name = string
      id            = optional(string)
    })

    name_bypass = optional(string)

    priority = number

    nat_rule_collections = optional(list(object({
      name_config = object({
        resource_name   = string
        endpoint_suffix = optional(string)
      })

      priority            = number
      protocols           = string
      destination_address = optional(string)
      destination_ports   = optional(string)

      rules = list(object({
        name                 = string
        description          = string
        mgmt_table_reference = string
        source_addresses     = optional(list(string))
        source_ip_groups     = optional(list(string))
        translated_address   = optional(string)
        translated_fqdn      = optional(string)
        translated_port      = number
      }))
    })))

    application_rule_collections = optional(list(object({
      name_config = object({
        resource_name   = string
        endpoint_suffix = optional(string)
      })

      action                = string
      priority              = number
      destination_addresses = optional(list(string))
      destination_urls      = optional(list(string))
      destination_fqdns     = optional(list(string))
      destination_fqdn_tags = optional(list(string))
      web_categories        = optional(list(string))

      protocols = optional(list(object({
        type = string
        port = number
      })))

      rules = set(object({
        name                 = string
        description          = string
        mgmt_table_reference = string
        source_addresses     = optional(list(string))
        source_ip_groups     = optional(list(string))

        http_headers = optional(list(object({
          name  = string
          value = string
        })))
      }))
    })))

    network_rule_collections = optional(list(object({
      name_config = object({
        resource_name   = string
        endpoint_suffix = optional(string)
      })

      action                = string
      priority              = number
      protocols             = list(string)
      destination_ports     = list(string)
      destination_addresses = optional(list(string))
      destination_ip_groups = optional(list(string))
      destination_fqdns     = optional(list(string))

      rules = set(object({
        name                 = string
        description          = string
        mgmt_table_reference = string
        source_addresses     = optional(list(string))
        source_ip_groups     = optional(list(string))
      }))
    })))

    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  }))

  default = []
}