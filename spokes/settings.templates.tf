locals {
  template = {
    location = "westeurope"
    tags = {
      provisined_with          = "terraform"
      terraform_repository_url = "https://github.com/leonardpolz/tf-az-caf-alz.git"
    }
  }


  spoke_template = merge(
    local.template, {
      resource_group_name = module.rg_spokes.resource_groups["spokes"].name
    }
  )
}
