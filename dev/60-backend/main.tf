# source --> terraform open source modules in github (no URL required for these)

module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami  = data.aws_ami.ami.id
  name = local.resource_name

  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.backend_tags,
    {
      Name = local.resource_name
    }
  )
}

resource "null_resource" "backend_configure" {
  # Change of instance id requires re-provisioning
  triggers = {
    instance_id = module.backend.id
  }

  # Connect to the server remotely and run the script 
  connection {
    host     = module.backend.private_ip
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
  }

  # Copy the file from local and run inside the remote server
  provisioner "file" {
    source      = "${var.backend_tags.Component}.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo sh /tmp/backend.sh ${var.backend_tags.Component} ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "backend_stop" {
  instance_id = module.backend.id
  state       = "stopped"
  depends_on  = [null_resource.backend_configure]
}

resource "aws_ami_from_instance" "backend_ami" {
  name               = local.resource_name
  source_instance_id = module.backend.id
  depends_on         = [aws_ec2_instance_state.backend_stop]
}

resource "null_resource" "backend_delete" {
  # Change of instance id requires re-provisioning
  triggers = {
    instance_id = module.backend.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.backend.id}"
  }

  depends_on = [aws_ami_from_instance.backend_ami]
}