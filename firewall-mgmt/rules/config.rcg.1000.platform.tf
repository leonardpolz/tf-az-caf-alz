locals {
  platform = {
    name_config = {
      workload_name = "platform"
    }

    priority = 1000

    application_rule_collections = [
      {
        name_config = {
          resource_name   = "storage-accounts"
          endpoint_suffix = "blob"
        }

        priority = 1000
        action   = "Allow"

        destination_fqdns = [
          "*.blob.core.windows.net",
          "*.privatelink.blob.core.windows.net",
        ]

        protocols = [
          {
            port = 443
            type = "Https"
          }
        ]

        rules = []
      },
      {
        name_config = {
          resource_name = "sql-instances"
        }

        priority = 1100
        action   = "Allow"

        destination_fqdns = [
          "*.database.windows.net",
          "*.privatelink.database.windows.net",
        ]

        protocols = [
          {
            port = 1433
            type = "Mssql"
          }
        ]

        rules = []
      },
      {
        name_config = {
          resource_name = "key-vaults"
        }

        priority = 1200
        action   = "Allow"

        destination_fqdns = [
          "*.vault.azure.net",
          "*.privatelink.vault.azure.net"
        ]

        protocols = [
          {
            port = 443
            type = "Https"
          }
        ]

        rules = []
      },
      {
        name_config = {
          resource_name = "databricks"
        }

        priority = 1300
        action   = "Allow"

        destination_fqdns = [
          "*.dfs.core.windows.net",
          "*.privatelink.dfs.core.windows.net"
        ]

        protocols = [
          {
            port = 443
            type = "Https"
          }
        ]

        rules = [
          {
            name                 = "Onprem Proxy"
            description          = "Onprem Proxy -> All Databricks Services"
            mgmt_table_reference = "68pe3tj6"

            source_ip_groups = [
              var.ip_groups["proxy_onprem"].id
            ]
          }
        ]
      },
      {
        name_config = {
          resource_name = "servicebus"
        }

        priority = 1400
        action   = "Allow"

        destination_fqdns = [
          "*.servicebus.windows.net",
          "*.privatelink.servicebus.windows.net"
        ]

        protocols = [
          {
            port = 443
            type = "Https"
          }
        ]

        rules = []
      },
      {
        name_config = {
          resource_name   = "storage-accounts"
          endpoint_suffix = "file"
        }

        priority = 1500
        action   = "Allow"

        destination_fqdns = [
          "*.file.core.windows.net",
          "*.privatelink.file.core.windows.net",
        ]

        protocols = [
          {
            port = 443
            type = "Https"
          }
        ]

        rules = []
      },
    ]

    network_rule_collections = []
  }
}
