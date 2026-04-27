
resource "google_service_account" "runtime_sa" {
  account_id   = "sa-wb-${var.instance_name}"
  display_name = "Runtime SA for ${var.instance_name}"
  description  = "Dedicated runtime identity for ${var.user_email}'s notebook"
}

resource "google_service_account_iam_member" "sa_user_binding" {
  service_account_id = google_service_account.runtime_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = var.tf_runner_identity
}

resource "google_project_iam_member" "sa_storage_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.runtime_sa.email}"
}
