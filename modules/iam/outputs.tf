output "gcp_service_account_email" {
  value = google_service_account.runtime_sa.email
}