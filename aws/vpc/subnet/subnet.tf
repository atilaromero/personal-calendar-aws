# Creates 2 subnets, one public and one private
variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
  description = "example: aws_vpc.main.id"
}
variable "public_rt_id" {
  type = string
  description = "example: aws_route_table.public_rt.id"
}
variable "availability_zone" {
  type = string
  description = "example: us-east-1a"
}
variable public_CIDR {
  type = string
  description = "example: 10.0.1.0/24"
}
variable private_CIDR {
  type = string
  description = "example: 10.0.101.0/24"
}

resource "aws_subnet" "private_subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.private_CIDR
  availability_zone = var.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name} Private"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.public_CIDR
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name} Public"
  }
}
resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = var.public_rt_id
}
