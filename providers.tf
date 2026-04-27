terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.29.0"
    }
  }

  backend "gcs" {
    bucket = "vasu_workbench_automation"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone = var.gcp_zone
}
