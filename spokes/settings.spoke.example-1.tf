locals {
  example_1_spoke = merge(
    # Reference from settings.templates.tf
    local.spoke_template, {
      tf_id = "example_1"
      name  = "vnet-example-1"

      address_space = ["10.100.1.0/28"]

      subnets = [{
        tf_id = "default"

        name = "snet-default"

        address_prefixes = ["10.100.1.0/28"]

        network_security_group_settings = {

          name = "nsg-example-1-default"

          security_rules = [
            {
              tf_id = "inbound_allow_all"
              name  = "inbound-allow-all"

              description                = "Allow all inbound traffic"
              protocol                   = "*"
              source_port_range          = "*"
              source_address_prefix      = "*"
              destination_port_range     = "*"
              destination_address_prefix = "*"
              access                     = "Allow"
              priority                   = 100
              direction                  = "Inbound"
            },
            {
              tf_id = "outbound_allow_all"
              name  = "outbound-allow-all"

              description                = "Allow all inbound traffic"
              protocol                   = "*"
              source_port_range          = "*"
              source_address_prefix      = "*"
              destination_port_range     = "*"
              destination_address_prefix = "*"
              access                     = "Allow"
              priority                   = 110
              direction                  = "Outbound"
            }
          ]
        }
      }]
    }
  )
}
