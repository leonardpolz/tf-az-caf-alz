# Configure the custom landing zones to deploy in
# addition to the core resource hierarchy
locals {
  custom_landing_zones = {

  }

  subscription_id_overrides = {
    #------------------------------------------------------#
    # This variable is used to associate Azure subscription_ids
    # with the built-in Enterprise-scale Management Groups.
    # Simply add one or more Subscription IDs to any of the
    # built-in Management Groups listed below as required.
    #------------------------------------------------------#
    root           = []
    decommissioned = []
    sandboxes      = []
    landing-zones  = [] # Not recommended, put Subscriptions in child management groups.
    platform       = [] # Not recommended, put Subscriptions in child management groups.
    connectivity   = [] # Not recommended, put Subscriptions in child management groups.
    management     = [] # Not recommended, put Subscriptions in child management groups.
    identity       = [] # Not recommended, put Subscriptions in child management groups.
    demo-corp      = []
    demo-online    = []
    demo-sap       = []
  }

  archetype_config_overrides = {
    root = {
      archetype_id     = "root"
      enforcement_mode = {}
      parameters       = {}
      access_control   = {}
    }

    decommissioned = {
      archetype_id     = "default_empty"
      enforcement_mode = {}
      parameters       = {}
      access_control   = {}
    }

    sandboxes = {
      archetype_id     = "default_empty"
      enforcement_mode = {}
      parameters       = {}
      access_control   = {}
    }

    landing-zones = {
      archetype_id     = "default_empty"
      enforcement_mode = {}
      parameters       = {}
      access_control   = {}
    }

    platform = {
      archetype_id     = "default_empty"
      enforcement_mode = {}
      parameters       = {}
      access_control   = {}
    }

    connectivity = {
      archetype_id     = "default_empty"
      enforcement_mode = {}
      parameters       = {}
      access_control   = {}
    }

    management = {
      archetype_id     = "default_empty"
      enforcement_mode = {}
      parameters       = {}
      access_control   = {}
    }

    identity = {
      archetype_id     = "default_empty"
      enforcement_mode = {}
      parameters       = {}
      access_control   = {}
    }
  }
}
