provider "aws" {
  profile = var.aws_provider_profile
  region  = local.aws_region
}

locals {
  aws_region          = "us-east-1"
  internal_cidr_block = "10.10.10.0/24"
  external_cidr_block = "0.0.0.0/0"
}

resource "aws_vpc" "project_vpc" {
  cidr_block = local.internal_cidr_block
}

resource "aws_subnet" "project_subnet" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = local.internal_cidr_block
  availability_zone = "${local.aws_region}d"
}

resource "aws_security_group" "project_security_group" {
  name   = "project_security_group"
  vpc_id = aws_vpc.project_vpc.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [local.external_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.external_cidr_block]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "access_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.access_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.access_key.private_key_pem}' > ../../../'${var.key_name}'.pem
      chmod 400 ../../../${var.key_name}.pem
    EOT
  }
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.project_subnet.id
  associate_public_ip_address = true
  key_name                    = var.key_name

  vpc_security_group_ids = [
    aws_security_group.project_security_group.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }

  depends_on = [ aws_security_group.project_security_group ]
}