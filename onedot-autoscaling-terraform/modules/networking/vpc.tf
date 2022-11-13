resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc-cidr


  # Makes your instances shared on the host.
  instance_tenancy = "default"

  #  Enable/disable DNS support in the VPC.
  enable_dns_support = true

  # . Enable/disable DNS hostnames in the VPC.
  enable_dns_hostnames = true


  tags = {
    Name = "vpc-${var.environment}"
  }
}

resource "aws_subnet" "pub_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub-subnet-cidr-a
  availability_zone = var.az-a

 
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                           = "public-ap-southeast-1a${var.environment}"
  }
}


resource "aws_subnet" "pub_subnet_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub-subnet-cidr-b
  availability_zone = var.az-b

 
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                           = "public-ap-southeast-1b-${var.environment}"
  }
}

resource "aws_subnet" "pri_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pri-subnet-cidr-a
  availability_zone = var.az-a

 
  map_public_ip_on_launch = false

  # A map of tags to assign to the resource.
  tags = {
    Name                           = "private-ap-southeast-1a-${var.environment}"
  }
}


resource "aws_subnet" "pri_subnet_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pri-subnet-cidr-b
  availability_zone = var.az-b

 
  map_public_ip_on_launch = false

  # A map of tags to assign to the resource.
  tags = {
    Name                           = "private-ap-southeast-1b-${var.environment}"
  }
}


resource "aws_internet_gateway" "igw" {
  # The VPC ID to create in.
  vpc_id = aws_vpc.my_vpc.id

  # A map of tags to assign to the resource.
  tags = {
    Name = "igw-${var.environment}"
  }
}





