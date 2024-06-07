data "terraform_remote_state" "spokes" {
  backend = "local"

  config = {
    path = "${path.module}/../spokes/connectivity.tfstate"
  }
}
