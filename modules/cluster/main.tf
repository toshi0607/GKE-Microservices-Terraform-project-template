terraform {
  required_version = "~> 1.2"
  required_providers {
    google = ">= 4.32.0"
  }
}

locals {
  service_name_with_env = "${var.service_name}-${var.environment}"
}

# https://www.terraform.io/docs/providers/google/guides/using_gke_with_terraform.html
# https://www.terraform.io/docs/providers/google/r/container_cluster.html
resource "google_container_cluster" "primary" {
  name     = "primary"
  project  = module.project.project_id
  location = var.gcp_region

  # https://cloud.google.com/kubernetes-engine/docs/how-to/alias-ips
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }

  workload_identity_config {
    workload_pool = "${module.project.project_id}.svc.id.goog"
  }

  initial_node_count       = 1
  remove_default_node_pool = true
}

# https://www.terraform.io/docs/providers/google/r/container_node_pool.html
resource "google_container_node_pool" "primary" {
  name     = "primary"
  project  = module.project.project_id
  location = var.gcp_region

  cluster    = google_container_cluster.primary.name
  node_count = 1
  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    # https://cloud.google.com/compute/docs/access/service-accounts#authorization
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}

module "project" {
  source = "../project"

  gcp_project = local.service_name_with_env

}
