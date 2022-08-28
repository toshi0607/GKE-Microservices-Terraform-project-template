module "cluster" {
  source = "../../modules/cluster"

  # e.g. 
  # service_name = "toshi0607-20220822-cluster"
  service_name    = 【YOUR SERVICE】
  environment     = "dev"
}

provider "google" {
  # e.g. 
  # project = "terraform-toshi0607"
  project = 【YOUR PROJECT】
  region  = "asia-northeast1"
}

terraform {
  backend "gcs" {
    # e.g. 
    # bucket = "tf-state-toshi0607-20201126-test"
    bucket = 【YOUR BUCKET】
    prefix = "terraform/k8s-cluster/terraform_state"
  }

  required_providers {
    google      = ">= 4.32.0"
  }
}
