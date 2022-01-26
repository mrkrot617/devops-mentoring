terraform {
  backend "s3" {
    bucket = "mentoring-terraform-states"
    region = "us-east-2"
    key    = "jenkins/terraform.tfstate"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  profile = var.aws_provider_profile
  region  = var.aws_region
}

resource "aws_vpc" "project_vpc" {
  cidr_block = "10.10.10.0/24"
}

resource "aws_internet_gateway" "project_internet_gateway" {
  vpc_id = aws_vpc.project_vpc.id
}

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_internet_gateway.id
  }
}

resource "aws_subnet" "project_subnet" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "10.10.10.0/28"
  availability_zone = "${var.aws_region}d"
}

resource "aws_route_table_association" "public_RT_association" {
  subnet_id      = aws_subnet.project_subnet.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_security_group" "jenkins_security_group" {
  name   = "jenkins_security_group"
  vpc_id = aws_vpc.project_vpc.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "access_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.access_key.public_key_openssh
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.project_subnet.id
  associate_public_ip_address = true
  key_name                    = var.key_name

  vpc_security_group_ids = [
    aws_security_group.jenkins_security_group.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp3" # sc1
  }
}