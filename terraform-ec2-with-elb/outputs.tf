output "tf_http_server_sg_details" {
  value = aws_security_group.tf_http_server_sg
}

output "tf_http_server_public_dns_details" {
  value = values(aws_instance.tf_http_servers).*.id
}

output "tf_elb_public_dns_details" {
  value = aws_elb.tf_elb
}

