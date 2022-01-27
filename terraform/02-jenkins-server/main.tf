terraform {
  backend "s3" {
    key = "jenkins/terraform.tfstate"
  }
}

provider "aws" {
  profile = var.aws_provider_profile
  region  = var.aws_region
}

data "terraform_remote_state" "remote_network" {
  backend = "s3"

  config = {
    bucket = "mentoring-terraform-states"
    region = "us-east-2"
    key    = "network/terraform.tfstate"
  }
}

resource "aws_security_group" "jenkins_security_group" {
  name   = "jenkins_security_group"
  vpc_id = data.terraform_remote_state.remote_network.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_external_cidr
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "tls_jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.tls_jenkins_key.public_key_openssh
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = data.terraform_remote_state.remote_network.outputs.subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  vpc_security_group_ids = [
    aws_security_group.jenkins_security_group.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = 12
    volume_type           = "gp3"
  }
}

resource "local_file" "ansible_inventory" {
  filename = "../../ansible/inventory"
  file_permission = "0644"

  content = templatefile("../inventory.tmpl",
    {
      jenkins_ip = aws_instance.jenkins.public_ip,
      default_user = var.default_username
    }
  )
}
