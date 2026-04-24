resource "google_compute_network" "vpc_network" {
  project                 = var.gcp_project_id
  name                    = var.vpc_network_name
  auto_create_subnetworks = var.gcp_auto_subnet_creation_flag
}

resource "google_compute_subnetwork" "main_subnet" {
  name          = var.gcp_main_subnet_name
  ip_cidr_range = var.gcp_main_subnet_cidr
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

