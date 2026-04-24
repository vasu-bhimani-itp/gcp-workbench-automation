variable "gcp_project_id" {
  type = string
  default = ""
}

variable "vpc_network_name" {
  type = string
  default = "gcp_main_vpc_for_workbench"
}

variable "gcp_auto_subnet_creation_flag" {
  default = "flase"
}

variable "gcp_main_subnet_name" {
  default = "main_subnet"
}

variable "gcp_main_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "gcp_region" {
  default = "us-central1"
}