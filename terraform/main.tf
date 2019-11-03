terraform {
  backend "s3" {}
}

provider "aws" {
}

data "aws_ami" "ami" {
  owners = ["amazon"]

  filter {
    name = "name"
    # Amazon Linux 2 AMI x86_64 gp2 (SSD)
    values = ["amzn2-ami-hvm-2.*x86_64-gp2"]
  }

  most_recent = true
}

# EC2

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.web.key_name
  user_data              = <<EOF
    #!/bin/sh
    yum install -y httpd
    systemctl enable --now httpd
    echo "Provisioned by Terraform - $(hostname -f)" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "terraform-ec2"
    Environment = "dev"
  }
}

# Security Group

resource "aws_security_group" "web" {
  name = "web"

  ingress {
    description = "Allow incomming SSH connections"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow incomming HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SSH Key Pair

resource "aws_key_pair" "web" {
  key_name   = "web"
  public_key = tls_private_key.id_rsa.public_key_openssh
}

resource "tls_private_key" "id_rsa" {
  algorithm = "RSA"
}

resource "local_file" "id_rsa" {
  sensitive_content = tls_private_key.id_rsa.private_key_pem
  filename          = "${path.module}/id_rsa"
  file_permission   = "0400"
}

resource "local_file" "id_rsa_pub" {
  content         = tls_private_key.id_rsa.public_key_pem
  filename        = "${path.module}/id_rsa.pub"
  file_permission = "0400"
}
