# source is custom module

module "mysql_sg" {
  source       = "git::https://github.com/sprojexdevops/terraform-modules.git//modules/sg?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "mysql"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.mysql_sg_tags
}

module "backend_sg" {
  source       = "git::https://github.com/sprojexdevops/terraform-modules.git//modules/sg?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "backend"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.backend_sg_tags
}

module "frontend_sg" {
  source       = "git::https://github.com/sprojexdevops/terraform-modules.git//modules/sg?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "frontend"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.frontend_sg_tags
}

module "ansible_sg" {
  source       = "git::https://github.com/sprojexdevops/terraform-modules.git//modules/sg?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "ansible"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.ansible_sg_tags
}

module "bastion_sg" {
  source       = "git::https://github.com/sprojexdevops/terraform-modules.git//modules/sg?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "bastion"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.bastion_sg_tags
}

module "app_alb_sg" {
  source       = "git::https://github.com/sprojexdevops/terraform-modules.git//modules/sg?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "app-alb"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.app_alb_sg_tags
}

module "web_alb_sg" {
  source       = "git::https://github.com/sprojexdevops/terraform-modules.git//modules/sg?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "web-alb"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.web_alb_sg_tags
}

module "vpn_sg" {
  source       = "git::https://github.com/sprojexdevops/terraform-modules.git//modules/sg?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "vpn"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.vpn_sg_tags
}

resource "aws_security_group_rule" "mysql_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.sg_id
  security_group_id        = module.mysql_sg.sg_id
}

# resource "aws_security_group_rule" "backend_frontend" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   source_security_group_id = module.frontend_sg.sg_id
#   security_group_id        = module.backend_sg.sg_id
# }

# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.frontend_sg.sg_id
# }


###########################
# Rules for Ansible ports #
###########################
resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ansible_sg.sg_id
}

# resource "aws_security_group_rule" "mysql_ansible" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   source_security_group_id = module.ansible_sg.sg_id
#   security_group_id        = module.mysql_sg.sg_id
# }

resource "aws_security_group_rule" "backend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.sg_id
  security_group_id        = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.sg_id
  security_group_id        = module.frontend_sg.sg_id
}


###########################
# Rules for bastion ports #
###########################
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}

resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  count                    = length(var.bastion_to_backend_ports)
  type                     = "ingress"
  from_port                = var.bastion_to_backend_ports[count.index]
  to_port                  = var.bastion_to_backend_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  count                    = length(var.bastion_to_frontend_ports)
  type                     = "ingress"
  from_port                = var.bastion_to_frontend_ports[count.index]
  to_port                  = var.bastion_to_frontend_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.frontend_sg.sg_id
}


###########################
# Rules for app-alb ports #
###########################
resource "aws_security_group_rule" "backend_app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id        = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_bastion" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.app_alb_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend_sg.sg_id
  security_group_id        = module.app_alb_sg.sg_id
}

###########################
# Rules for web-alb ports #
###########################
resource "aws_security_group_rule" "frontend_web_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.web_alb_sg.sg_id
  security_group_id        = module.frontend_sg.sg_id
}

resource "aws_security_group_rule" "web_alb_public" {
  count             = length(var.public_to_web_alb_ports)
  type              = "ingress"
  from_port         = var.public_to_web_alb_ports[count.index]
  to_port           = var.public_to_web_alb_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.sg_id
}

#######################
# Rules for VPN ports #
#######################
resource "aws_security_group_rule" "vpn_public" {
  count             = length(var.public_to_vpn_ports)
  type              = "ingress"
  from_port         = var.public_to_vpn_ports[count.index]
  to_port           = var.public_to_vpn_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_vpn" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id        = module.app_alb_sg.sg_id
}

resource "aws_security_group_rule" "backend_vpn" {
  count                    = length(var.vpn_to_backend_ports)
  type                     = "ingress"
  from_port                = var.vpn_to_backend_ports[count.index]
  to_port                  = var.vpn_to_backend_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id        = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "frontend_vpn" {
  count                    = length(var.vpn_to_frontend_ports)
  type                     = "ingress"
  from_port                = var.vpn_to_frontend_ports[count.index]
  to_port                  = var.vpn_to_frontend_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id        = module.frontend_sg.sg_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id        = module.mysql_sg.sg_id
}