provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {

}

// Create Security Group
resource "aws_security_group" "tf_http_server_sg" {
  name = "tf_http_server_sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "tf_http_server_sg"
  }
}

// Creating EC2 resource
resource "aws_instance" "tf_http_server" {
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "AWSKP1-Mac"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.tf_http_server_sg.id]
  subnet_id = data.aws_subnets.default_subnets.ids[0]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo Welcome to Upstream Solutions - Virtual Server At ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
}