//output "public_ip" {
//  value = aws_spot_instance_request.this.public_ip
//}
//
//output "instance_id" {
//  value = aws_spot_instance_request.this.id
//}


output "public_ip" {
  value = var.create_spot ? join("", aws_spot_instance_request.this.*.public_ip) : join("", aws_instance.this.*.public_ip)
}

//output "instance_id" {
//  value = aws_spot_instance_request.this.id
//}

