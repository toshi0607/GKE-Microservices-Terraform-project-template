module "microservice" {
  source = "../"

  gke_project  = data.terraform_remote_state.cluster.outputs.gke_project_id
  service_name = var.service_name
  environment  = "dev"
}

// https://www.terraform.io/docs/providers/terraform/d/remote_state.html
data "terraform_remote_state" "cluster" {
  backend = "gcs"

  config = {
    bucket = var.cluster_tfstate_bucket
    prefix = var.cluster_tfstate_prefix
  }
}

# https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/auth
data "google_client_config" "provider" {}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started#provider-setup
provider "kubernetes" {
  host  = "https://${data.terraform_remote_state.cluster.outputs.gke_endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.gke_ca_certificate,
  )
}

provider "google" {}
