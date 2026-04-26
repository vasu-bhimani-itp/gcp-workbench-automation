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

# 3. Provision the Vertex AI Workbench Instance
resource "google_workbench_instance" "notebook" {
  name     = var.instance_name
  location = "${var.region}-a" # Vertex AI instances require a specific zone

  gce_setup {
    machine_type      = var.machine_type
    disable_public_ip = true # Security: Force private IP only

    service_accounts {
      email = google_service_account.runtime_sa.email
    }

    network_interfaces {
      network = var.vpc_network_id
      subnet  = var.subnet_id
    }

    metadata = {
      # FinOps: Aggressive Idle Shutdown
      idle-timeout-seconds = var.idle_timeout_seconds
    }
  }

  # IAP zero-trust access
  disable_proxy_access = false

  instance_owners = [var.user_email]

  #Cost Allocation Labels
  # FinOps: Mandatory Cost Allocation Labels
  labels = merge(
    var.base_labels,
    {
      owner           = replace(replace(var.user_email, "@", "-at-"), ".", "-dot-")
      github_username = var.github_username
      cost_center     = "data_science"
      instance_id     = var.instance_name
    }
  )

  depends_on = [
    google_service_account_iam_member.sa_user_binding
  ]
}