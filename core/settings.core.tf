# Configure the custom landing zones to deploy in
# addition to the core resource hierarchy
locals {
  custom_landing_zones = {
    "test-online-example-1" = {
      display_name               = "my-custom-landing-zone-1"
      parent_management_group_id = "test-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "customer_online"
        parameters     = {}
        access_control = {}
      }
    }
  }
}
