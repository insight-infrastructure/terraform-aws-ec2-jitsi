resource "random_pet" "this" {}

locals {
  fqdn = "${var.hostname}.${var.root_domain_name}"
}

module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"

  name = var.name

  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}

module "ami" {
  source = "github.com/insight-infrastructure/terraform-aws-ami.git?ref=v0.1.0"
}

resource "aws_key_pair" "this" {
  public_key = file(var.public_key_path)
  tags       = module.label.tags
}

resource "aws_spot_instance_request" "this" {
  count = var.create_spot ? 1 : 0

  ami           = module.ami.ubuntu_1804_ami_id
  instance_type = var.instance_type

  spot_price           = "1"
  spot_type            = "persistent"
  wait_for_fulfillment = true

  root_block_device {
    volume_size = var.root_volume_size
  }

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name = aws_key_pair.this.key_name

  tags = module.label.tags
}


resource "aws_instance" "this" {
  count         = var.create_spot ? 0 : 1
  ami           = module.ami.ubuntu_1804_ami_id
  instance_type = var.instance_type

  //  spot_price           = "1"
  //  spot_type            = "persistent"
  //  wait_for_fulfillment = true

  root_block_device {
    volume_size = var.root_volume_size
  }

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name = aws_key_pair.this.id

  tags = module.label.tags

  depends_on = [aws_key_pair.this]
}

module "ansible" {
  source = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=v0.9.0"
  ip     = var.create_spot ? join("", aws_spot_instance_request.this.*.public_ip) : join("", aws_instance.this.*.public_ip)
  //  ip               = aws_spot_instance_request.this.public_ip
  user             = "ubuntu"
  private_key_path = var.private_key_path

  playbook_file_path = "${path.module}/ansible/main.yml"
  playbook_vars      = merge({ jitsi_meet_server_name : local.fqdn }, var.playbook_vars)

  requirements_file_path = "${path.module}/ansible/requirements.yml"
}

data "aws_route53_zone" "root" {
  name = "${var.root_domain_name}."
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.root.id
  name    = local.fqdn
  type    = "A"
  ttl     = "300"
  records = [var.create_spot ? join("", aws_spot_instance_request.this.*.public_ip) : join("", aws_instance.this.*.public_ip)]
}
