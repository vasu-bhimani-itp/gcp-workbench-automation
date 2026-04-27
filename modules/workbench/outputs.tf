output "workbench_id" {
  description = "The ID of the provisioned Workbench instance"
  value       = google_workbench_instance.notebook.id
}

# output "runtime_sa_email" {
#   description = "The email of the dedicated runtime service account"
#   value       = google_service_account.runtime_sa.email
# }

output "proxy_uri" {
  description = "The URI to securely access the JupyterLab interface"
  value       = google_workbench_instance.notebook.proxy_uri
}