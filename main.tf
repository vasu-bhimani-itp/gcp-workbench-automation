module "vertex_workbench" {
  source = "./modules/workbench"

  project_id         = var.project_id
  region             = var.region
  vpc_network_id     = var.vpc_network_id
  subnet_id          = var.subnet_id
  user_email         = var.user_email
  instance_name      = var.instance_name
  machine_type       = var.machine_type
  tf_runner_identity = var.tf_runner_identity

  # FinOps Guardrail: Hardcoded at the module level so users cannot bypass it
  idle_timeout_seconds = "7200" # 2 hours

  base_labels = {
    managed_by  = "terraform"
    platform    = "self_service"
    environment = "production"
  }
}