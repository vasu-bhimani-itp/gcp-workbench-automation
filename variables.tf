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