variable "project_id" {
  description = "GCP project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "GCP region for the resources"
  type        = string
}

variable "vpc_network_id" {
  description = "VPC network ID to attach the notebook instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID within the VPC"
  type        = string
}

variable "user_email" {
  description = "User email who will own and access the notebook instance"
  type        = string
}

variable "instance_name" {
  description = "Name of the Vertex AI Workbench instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the notebook instance (e.g., e2-standard-4)"
  type        = string
}

variable "idle_timeout_seconds" {
  description = "Idle timeout in seconds before the notebook shuts down"
  type        = number
}

variable "base_labels" {
  description = "Base labels to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "tf_runner_identity" {
  description = "Service account or identity running Terraform"
  type        = string
}

variable "github_username" {
  description = "The GitHub username of the deployer"
  type        = string
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

variable "gcp_service_account_email" {
  description = "Email of the service account for the workbench runtime"
  type        = string
}