locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = []
      vwan_hub_networks = [
        {
          enabled = true
          config = {
            address_prefix = "10.200.0.0/22"
            location       = "westeurope"
            sku            = "Basic"
            routes         = []
            expressroute_gateway = {
              enabled = false
              config = {
                scale_unit                    = 1
                allow_non_virtual_wan_traffic = false
              }
            }
            vpn_gateway = {
              enabled = false
              config = {
                bgp_settings       = []
                routing_preference = ""
                scale_unit         = 1
              }
            }
            azure_firewall = {
              enabled = false
              config = {
                enable_dns_proxy              = false
                dns_servers                   = []
                sku_tier                      = "Basic"
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = {}
                availability_zones = {
                  zone_1 = true
                  zone_2 = false
                  zone_3 = false
                }
              }
            }
            spoke_virtual_network_resource_ids = []
            secure_spoke_virtual_network_resource_ids = [
              data.terraform_remote_state.spokes.outputs.spokes.virtual_networks["dns_resolver"].id,
              data.terraform_remote_state.spokes.outputs.spokes.virtual_networks["example_1"].id,
              data.terraform_remote_state.spokes.outputs.spokes.virtual_networks["example_2"].id
            ]
            enable_virtual_hub_connections = true
          }
        },
      ]
      ddos_protection_plan = {
        enabled = false
        config = {
          location = "westeurope"
        }
      }
      dns = {
        enabled = true
        config = {
          location = null
          enable_private_link_by_service = {
            azure_api_management                 = false
            azure_app_configuration_stores       = false
            azure_arc                            = false
            azure_automation_dscandhybridworker  = false
            azure_automation_webhook             = false
            azure_backup                         = false
            azure_batch_account                  = false
            azure_bot_service_bot                = false
            azure_bot_service_token              = false
            azure_cache_for_redis                = false
            azure_cache_for_redis_enterprise     = false
            azure_container_registry             = false
            azure_cosmos_db_cassandra            = false
            azure_cosmos_db_gremlin              = false
            azure_cosmos_db_mongodb              = false
            azure_cosmos_db_sql                  = false
            azure_cosmos_db_table                = false
            azure_data_explorer                  = false
            azure_data_factory                   = false
            azure_data_factory_portal            = false
            azure_data_health_data_services      = false
            azure_data_lake_file_system_gen2     = false
            azure_database_for_mariadb_server    = false
            azure_database_for_mysql_server      = false
            azure_database_for_postgresql_server = false
            azure_digital_twins                  = false
            azure_event_grid_domain              = false
            azure_event_grid_topic               = false
            azure_event_hubs_namespace           = false
            azure_file_sync                      = false
            azure_hdinsights                     = false
            azure_iot_dps                        = false
            azure_iot_hub                        = false
            azure_key_vault                      = false
            azure_key_vault_managed_hsm          = false
            azure_kubernetes_service_management  = false
            azure_machine_learning_workspace     = false
            azure_managed_disks                  = false
            azure_media_services                 = false
            azure_migrate                        = false
            azure_monitor                        = false
            azure_purview_account                = false
            azure_purview_studio                 = false
            azure_relay_namespace                = false
            azure_search_service                 = false
            azure_service_bus_namespace          = false
            azure_site_recovery                  = false
            azure_sql_database_sqlserver         = false
            azure_synapse_analytics_dev          = false
            azure_synapse_analytics_sql          = false
            azure_synapse_studio                 = false
            azure_web_apps_sites                 = false
            azure_web_apps_static_sites          = false
            cognitive_services_account           = false
            microsoft_power_bi                   = false
            signalr                              = false
            signalr_webpubsub                    = false
            storage_account_blob                 = true
            storage_account_file                 = false
            storage_account_queue                = false
            storage_account_table                = false
            storage_account_web                  = false
          }
          private_link_locations = [
            "westeurope",
          ]
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = false
          enable_private_dns_zone_virtual_network_link_on_spokes = false
          virtual_network_resource_ids_to_link = [
            data.terraform_remote_state.spokes.outputs.spokes.virtual_networks["dns_resolver"].id,
          ]
        }
      }
    }

    location = "westeurope"
    tags = {
      provisined_with          = "terraform"
      terraform_repository_url = "https://github.com/leonardpolz/tf-az-caf-alz.git"
    }

    advanced = {
      custom_settings_by_resource_type = {

        azurerm_resource_group = {

          # module.alz.azurerm_resource_group.connectivity["(...)"]
          dns = {
            ("westeurope") = {
              name = "my-custom-name-dns-zones"
            }
          }

          # module.alz.azurerm_resource_group.virtual_wan["(...)"] 
          virtual_wan = {
            ("westeurope") = {
              name = "my-custom-name-vwan"
            }
          }
        }

        # module.alz.azurerm_firewall_policy.virtual_wan["(...)"]
        azurerm_firewall_policy = {
          virtual_wan = {
            ("westeurope") = {
              name = "my-custom-name-fwp"
            }
          }
        }

        # # module.alz.azurerm_firewall.virtual_wan["(...)"]
        azurerm_firewall = {
          virtual_wan = {
            ("westeurope") = {
              name = "my-custom-name-fw"
            }
          }
        }

        # module.alz.azurerm_virtual_wan.virtual_wan["(...)"]
        azurerm_virtual_wan = {
          virtual_wan = {
            ("westeurope") = {
              name = "my-custom-name-wan"
            }
          }
        }

        # module.alz.azurerm_virtual_hub.virtual_wan["(...)"]
        azurerm_virtual_hub = {
          virtual_wan = {
            ("westeurope") = {
              name           = "my-custom-name-wanh"
              address_prefix = "10.100.0.0/23"
            }
          }
        }
      }
    }
  }
}
