provider "aws" {
    region = "eu-west-2"
}

variable vpc_cidr_kuber_block {}
variable private_subnet_cidr_block {}
variable public_subnet_cidr_block {}

# Dinamically obtain the Availability Zones data

data "aws_availability_zones" "azs" {}

module "kuber-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"
  
  name = "kuber-vpc"

  # Creating cird block for VPC
  cidr = var.vpc_cidr_kuber_block

  # Best practice creating one public and one private subnet for each AZ
  private_subnets = var.private_subnet_cidr_block
  public_subnets = var.public_subnet_cidr_block
  # Creatin Availability Zones
  azs = data.aws_availability_zones.azs.names

  # Enable Nat which all private subnets will route their internet traffic through the NAT and DNS
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true 

  #l
  tags = {
      "kubernetes.io/cluster/exadel-eks-cluster" = "shared"
  }

  public_subnet_tags = {
      "kubernetes.io/cluster/exadel-eks-cluster" = "shared"
      "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
      "kubernetes.io/cluster/exadel-eks-cluster" = "shared"
      "kubernetes.io/role/internal-elb" = 1
  }
}