provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "project_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "Project area"
  }
}

resource "aws_subnet" "project_subnet" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "10.10.10.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name = "Project domain"
  }
}

resource "aws_network_interface" "primary_network_interface" {
  subnet_id   = aws_subnet.project_subnet.id
  private_ips = ["10.10.10.10"]

  tags = {
    Name = "Primary network interface"
  }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-08e4e35cccc6189f4"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.primary_network_interface.id
    device_index         = 0
  }

  #  what is it?
  #  credit_specification {
  #    cpu_credits = "unlimited"
  #  }

  tags = {
    Name = "Jenkins"
  }
}