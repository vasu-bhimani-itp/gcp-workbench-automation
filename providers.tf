terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.29.0"
    }
  }

  backend "gcs" {
    bucket = "vasu_workbench_automation"
    # prefix = "terraform/state/workbench"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  # region  = join("-", slice(split("-", gcp_zone), 0, 2)) # Extracts region from zone (e.g., us-central1-a -> us-central1)
  zone = var.gcp_zone
}
