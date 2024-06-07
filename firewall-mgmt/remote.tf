data "terraform_remote_state" "connectivity" {
  backend = "local"

  config = {
    path = "${path.module}/../caf-connectivity/connectivity.tfstate"
  }
}
