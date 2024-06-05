data "terraform_remote_state" "connectivity" {
  backend = "local"

  config = {
    path = "${path.module}/../connectivity/connectivity.tfstate"
  }
}
