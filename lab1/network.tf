# VPC
resource "aws_vpc" "Inspection_VPC" { 
  cidr_block = "10.1.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Inspection VPC"
  }
}

# Subnet
resource "aws_subnet" "Inspection_VPC_Firewall_Subnet" {
  vpc_id     = aws_vpc.Inspection_VPC.id
  cidr_block = "10.1.1.0/28"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "Inspection VPC Firewall Subnet"
  }
}

resource "aws_subnet" "Inspection_VPC_Protected_Workload_Subnet" {
  vpc_id     = aws_vpc.Inspection_VPC.id
  cidr_block = "10.1.3.0/28"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "Inspection VPC Protected Workload Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "Inspection_VPC_IGW" {
  vpc_id = aws_vpc.Inspection_VPC.id

  tags = {
    Name = "Inspection VPC IGW"
  }
}
