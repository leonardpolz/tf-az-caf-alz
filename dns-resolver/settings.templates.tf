locals {
  template = {
    location = "westeurope"
    tags = {
      provisined_with          = "terraform"
      terraform_repository_url = "https://github.com/leonardpolz/tf-az-caf-alz.git"
    }
  }
}
