variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
  description = "example: aws_vpc.main.id"
}
variable igw_id {
  type = string
  description = "example: aws_internet_gateway.igw.id"
}
variable rt_id {
  type = string
  description = "example: aws_route_table.rt.id"
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
resource "aws_route" "igw" {
  gateway_id = var.igw_id
  route_table_id = var.rt_id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = var.rt_id
}
