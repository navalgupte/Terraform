provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {

}

// Create Security Group - HTTP Servers
resource "aws_security_group" "tf_http_server_sg" {
  name   = "tf_http_server_sg"
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

// Create Security Group - ELB
resource "aws_security_group" "tf_elb_sg" {
  name   = "tf_elb_sg"
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
}

// Creating ELB Resource
resource "aws_elb" "tf_elb" {
  name            = "tf-elb"
  subnets         = toset(data.aws_subnets.default_subnets.ids)
  security_groups = [aws_security_group.tf_elb_sg.id]
  instances       = values(aws_instance.tf_http_servers).*.id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

// Creating EC2 resource
resource "aws_instance" "tf_http_servers" {
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "AWSKP1-Mac"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.tf_http_server_sg.id]

  for_each  = toset(data.aws_subnets.default_subnets.ids)
  subnet_id = each.value

  tags = {
    name : "http_server_${each.value}"
  }

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