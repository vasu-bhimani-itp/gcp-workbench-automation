# 3. Provision the Vertex AI Workbench Instance
resource "google_workbench_instance" "notebook" {
  name     = var.instance_name
  location = "${var.region}-a" # Vertex AI instances require a specific zone

  gce_setup {
    machine_type      = var.machine_type
    disable_public_ip = true # Security: Force private IP only

    shielded_instance_config {
      enable_secure_boot          = true
      enable_vtpm                 = true
      enable_integrity_monitoring = true
    }

    boot_disk {
        disk_size_gb = var.boot_disk_size
      }

    dynamic "accelerator_configs" {
      for_each = var.accelerator_type != "NONE" ? [1] : []
        content {
          type       = var.accelerator_type
          core_count = tonumber(var.accelerator_count)
        }
      }


    service_accounts {
      email = var.gcp_service_account_email
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
}