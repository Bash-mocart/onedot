# Resource: aws_route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

resource "aws_route_table" "public" {
  # The VPC ID.
  vpc_id = aws_vpc.my_vpc.id

  route {
    # The CIDR block of the route.
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC internet gateway or a virtual private gateway.
    gateway_id = aws_internet_gateway.igw.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "public-${var.environment}"
  }
}

resource "aws_route_table" "private1" {
  # The VPC ID.
  vpc_id = aws_vpc.my_vpc.id

  route {
    # The CIDR block of the route.
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway.
    nat_gateway_id = aws_nat_gateway.gw1.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "pivate1-${var.environment}"
  }
}

resource "aws_route_table" "private2" {
  # The VPC ID.
  vpc_id = aws_vpc.my_vpc.id

  route {
    # The CIDR block of the route.
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway.
    nat_gateway_id = aws_nat_gateway.gw2.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "private2-${var.environment}"
  }
}
