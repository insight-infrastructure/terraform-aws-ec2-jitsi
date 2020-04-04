module "vpc_default" {
  source = "github.com/insight-infrastructure/terraform-aws-default-vpc.git?ref=v0.1.0"
}

resource "aws_security_group" "this" {
  vpc_id = module.vpc_default.vpc_id

  dynamic "ingress" {
    for_each = [
      22,
      80,
    443]
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = [
      "0.0.0.0/0"]
    }
  }

  ingress {
    from_port = 1000
    protocol  = "udp"
    to_port   = 1000
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}

module "defaults" {
  source    = "../.."
  subnet_id = module.vpc_default.subnet_ids[0]

  vpc_security_group_ids = [
  aws_security_group.this.id]

  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path

  root_domain_name = var.root_domain_name
}
