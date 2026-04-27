output "workbench_id" {
  description = "The ID of the provisioned Workbench instance"
  value       = module.vertex_workbench.workbench_id
}

# output "runtime_sa_email" {
#   description = "The email of the dedicated runtime service account"
#   value       = module.vertex_workbench.runtime_sa_email
# }

output "proxy_uri" {
  description = "The URI to securely access the JupyterLab interface"
  value       = module.vertex_workbench.proxy_uri
}