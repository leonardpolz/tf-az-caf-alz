# Configure custom identity resources settings
locals {
  configure_identity_resources = {
    settings = {
      identity = {
        config = {
          # Disable this policy as can conflict with Terraform
          enable_deny_subnet_without_nsg = false

          # Temporary Disabled
          enable_deny_rdp_from_internet     = false
          enable_deny_subnet_without_nsg    = false
          enable_deploy_azure_backup_on_vms = false
        }
      }
    }
  }
}
