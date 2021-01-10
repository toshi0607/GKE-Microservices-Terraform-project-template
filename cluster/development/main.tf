module "cluster" {
  source = "../../modules/cluster"

  # 例: toshi0607-20201221-cluster
  service_name    = 【YOUR SERVICE】
  environment     = "dev"
}

provider "google" {
  project = 【YOUR PROJECT】
  region  = "asia-northeast1"
}

provider "google-beta" {
  project = 【YOUR PROJECT】
  region  = "asia-northeast1"
}

terraform {
  backend "gcs" {
    bucket = 【YOUR BUCKET】
    prefix = "terraform/k8s-cluster/terraform_state"
  }

  required_providers {
    google      = ">= 3.34.0"
    google-beta = ">= 3.34.0"
  }
}
