terraform {
  backend "s3" {
    key = "network/terraform.tfstate"
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