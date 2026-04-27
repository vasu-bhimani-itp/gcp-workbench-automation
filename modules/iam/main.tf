# 1. Create the Least-Privilege Runtime Service Account
resource "google_service_account" "runtime_sa" {
  account_id   = "sa-wb-${var.instance_name}"
  display_name = "Runtime SA for ${var.instance_name}"
  description  = "Dedicated runtime identity for ${var.user_email}'s notebook"
}

# 2. Grant "Service Account User" role to the Deployer (Fixes the ActAs 403 Error)
# This MUST be the identity running Terraform (e.g., your GitHub Actions Service Account)
resource "google_service_account_iam_member" "sa_user_binding" {
  service_account_id = google_service_account.runtime_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = var.tf_runner_identity
}

# (Optional but recommended) Grant the Runtime SA baseline permissions to read from GCS
resource "google_project_iam_member" "sa_storage_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.runtime_sa.email}"
}