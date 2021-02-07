# Creates a VPC using 2 zones. Each zone has 2 subnets, one public and one private.
variable "name" {
  default = "App"
  description = "This name will appear as a prefix in network resource names"
}
variable "cidr_block" {
  default = "10.0.0.0/16"
  description = "CIDR of the VPC. Must be big enough to contain all subnets."
}
variable "region" {
  default = "us-east-1"
}
variable "subnet_1" {
  default = {
    availability_zone = "us-east-1a"
    public_CIDR = "10.0.1.0/24"
    private_CIDR = "10.0.101.0/24"
  }
  description = "2 subnets, one public and one private, in the same zone"
}

variable "subnet_2" {
  default = {
    availability_zone = "us-east-1b"
    public_CIDR = "10.0.2.0/24"
    private_CIDR = "10.0.102.0/24"
  }
  description = "2 subnets, one public and one private, in the same zone"
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.name} VPC"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name} IGW"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name} Public RT"
  }
  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }
}

module "subnet_1" {
  source = "./subnet"
  name = "${var.name} Subnet 1"
  vpc_id = aws_vpc.main.id
  public_rt_id = aws_route_table.public_rt.id
  availability_zone = var.subnet_1.availability_zone
  public_CIDR       = var.subnet_1.public_CIDR
  private_CIDR      = var.subnet_1.private_CIDR
}

module "subnet_2" {
  source = "./subnet"
  name = "${var.name} Subnet 2"
  vpc_id = aws_vpc.main.id
  public_rt_id = aws_route_table.public_rt.id
  availability_zone = var.subnet_2.availability_zone
  public_CIDR       = var.subnet_2.public_CIDR
  private_CIDR      = var.subnet_2.private_CIDR
}
