output "tf_http_server_sg_details" {
  value = aws_security_group.tf_http_server_sg
}

output "tf_http_server_public_dns_details" {
  value = aws_instance.tf_http_server.public_dns
}