locals {
  configure_management_resources = {
    settings = {
      log_analytics = {
        config = {
          retention_in_days = 30
        }
      }
      security_center = {
        config = {
          email_security_contact = "test@user.de"
        }
      }
    }

    location = "westeurope"

    tags = {
      provisioned_with         = "terraform"
      terraform_repository_url = "https://github.com/leonardpolz/tf-az-caf-template.git"
    }
  }
}
