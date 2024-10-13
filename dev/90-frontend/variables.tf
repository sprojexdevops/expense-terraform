variable "project_name" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "region" {
  default = "us-east-1"
}

variable "common_tags" {
  type = map(any)
  default = {
    Project     = "expense"
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "frontend_tags" {
  type = map(any)
  default = {
    Component = "frontend"
  }
}

variable "zone_name" {
  default = "sprojex.in"
}