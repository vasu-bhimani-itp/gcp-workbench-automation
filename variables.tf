variable "gcp_zone" {
  type    = string
  default = "asia-south1"
}


#------------------------------------------------------------
variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the infrastructure"
  type        = string
}

variable "vpc_network_id" {
  description = "The ID of the existing VPC network"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the existing private subnet"
  type        = string
}

variable "user_email" {
  description = "The email of the user requesting the workbench"
  type        = string
}

variable "instance_name" {
  description = "Unique name for the Workbench instance"
  type        = string
}

variable "machine_type" {
  description = "Compute engine machine type"
  type        = string
}

variable "tf_runner_identity" {
  description = "The IAM identity running Terraform (e.g., user:vasubhimani93@gmail.com)"
  type        = string
}

variable "github_username" {
  description = "The GitHub username of the deployer"
  type        = string
}


variable "idle_timeout_seconds" {
  description = "Idle timeout in seconds before the notebook shuts down"
  type        = number
}

variable "boot_disk_size" {
  description = "Boot disk size in GB for the notebook instance"
  type        = string
}

variable "accelerator_type" {
  description = "GPU accelerator type (e.g., NONE, NVIDIA_TESLA_T4, NVIDIA_TESLA_A100)"
  type        = string
}

variable "accelerator_count" {
  description = "Number of GPUs to attach"
  type        = string
}

variable "admin_email" {
  description = "Admin email for receiving alerts and notifications"
  type        = string
}

variable "gcp_service_account_email" {

}