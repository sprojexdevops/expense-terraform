# source --> terraform open source modules in github (no URL required for these)

resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("D:/joindevops/openvpn.pub")
}

module "vpn" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami  = data.aws_ami.openvpn_ami.id
  name = local.resource_name

  key_name = aws_key_pair.openvpn.key_name

  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.vpn_tags,
    {
      Name = local.resource_name
    }
  )
}