# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.215.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name: "${var.env_prefix}-igw"
  }
}

# Create subnets
# az1
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.215.0.0/27"
  map_public_ip_on_launch = true
  availability_zone = "${var.my_aws_region}a"

  tags = {
    Name: "${var.env_prefix}-Public-Subnet-1"
  }
}
resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.215.0.32/27"
  map_public_ip_on_launch = false
  availability_zone = "${var.my_aws_region}a"

  tags = {
    Name: "${var.env_prefix}-Private-Subnet-1"
  }
}
# az2
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.215.0.64/27"
  map_public_ip_on_launch = true
  availability_zone = "${var.my_aws_region}b"

  tags = {
    Name: "${var.env_prefix}-Public-Subnet-2"
  }
}
resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.215.0.96/27"
  map_public_ip_on_launch = false
  availability_zone = "${var.my_aws_region}b"

  tags = {
    Name: "${var.env_prefix}-Private-Subnet-2"
  }
}

# Create the Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name: "${var.env_prefix}-Route-Table"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name: "${var.env_prefix}-Private-Route-Table"
  }
}

# Create Route Table Associations
# public
resource "aws_route_table_association" "public-subnet-association-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public-subnet-association-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public.id
}
# private
resource "aws_route_table_association" "private-association-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private-association-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private.id
}

# End;