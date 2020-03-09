

data "aws_route53_zone" "root" {
  name = "${var.root_domain_name}."
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.root.id
  name    = local.fqdn
  type    = "A"
  ttl     = "300"
  records = [
  aws_eip.this.public_ip]
}
