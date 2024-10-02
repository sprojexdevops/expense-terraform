variable "project_name" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

# variable "sg_name" {
#   type    = string
# }

variable "common_tags" {
  type = map(any)
  default = {
    Project     = "expense"
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "mysql_sg_tags" {
  type = map(any)
  default = {
    Component = "mysql"
  }
}

variable "backend_sg_tags" {
  type = map(any)
  default = {
    Component = "backend"
  }
}

variable "frontend_sg_tags" {
  type = map(any)
  default = {
    Component = "frontend"
  }
}

variable "ansible_sg_tags" {
  type = map(any)
  default = {
    Component = "ansible"
  }
}

variable "bastion_sg_tags" {
  type = map(any)
  default = {
    Component = "bastion"
  }
}