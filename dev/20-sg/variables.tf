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

################
# bastion tags #
################
variable "bastion_sg_tags" {
  type = map(any)
  default = {
    Component = "bastion"
  }
}

variable "bastion_to_backend_ports" {
  type    = list(number)
  default = [22, 8080]
}

variable "bastion_to_frontend_ports" {
  type    = list(number)
  default = [22, 80]
}

################
# app-alb tags #
################
variable "app_alb_sg_tags" {
  type = map(any)
  default = {
    Component = "app-alb"
  }
}

############
# vpn tags #
############
variable "vpn_sg_tags" {
  type = map(any)
  default = {
    Component = "vpn"
  }
}

variable "public_to_vpn_ports" {
  type    = list(number)
  default = [22, 443, 943, 1194]
}

variable "vpn_to_backend_ports" {
  type    = list(number)
  default = [22, 8080]
}

variable "vpn_to_frontend_ports" {
  type    = list(number)
  default = [22, 80]
}