output "public_ip" {
  value = aws_spot_instance_request.this.public_ip
}

output "instance_id" {
  value = aws_spot_instance_request.this.id
}

output "key_name" {
  value = aws_key_pair.this.*.key_name[0]
}
