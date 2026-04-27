variable "tf_runner_identity" {
  description = "Service account or identity running Terraform"
  type        = string
}

variable "project_id" {
  description = "GCP project ID where resources will be created"
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