variable "project_name" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "common_tags" {
  type = map(any)
  default = {
    Project     = "expense"
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "app_alb_tags" {
  type = map(any)
  default = {
    Component = "application-alb"
  }
}

variable "zone_name" {
  type    = string
  default = "sprojex.in"
}