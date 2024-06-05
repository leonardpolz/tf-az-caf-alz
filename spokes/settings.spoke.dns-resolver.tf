locals {
  dns_resolver_spoke = merge(
    # Reference from settings.templates.tf
    local.spoke_template, {
      tf_id = "dns_resolver"
      name  = "vnet-my-custom-name-dns-resolver"

      address_space = ["10.100.0.0/27"]

      subnets = [{
        tf_id = "dns_resolver"

        name = "snet-my-custom-name-dns-resolver"

        address_prefixes = ["10.100.0.0/28"]

        delegations = [{
          name = "Microsoft.Network.dnsResolvers"

          service_delegation = {
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            name    = "Microsoft.Network/dnsResolvers"
          }
        }]

        network_security_group_settings = {

          name = "nsg-my-custom-name-dns-resolver"

          security_rules = [
            {
              tf_id = "inbound_allow_all"
              name  = "inbound-allow-all"

              description                = "Allow all inbound traffic"
              protocol                   = "*"
              source_port_range          = "*"
              source_address_prefix      = "*"
              destination_port_range     = "53"
              destination_address_prefix = "*"
              access                     = "Allow"
              priority                   = 100
              direction                  = "Inbound"
            }
          ]
        }
      }]
    }
  )
}
