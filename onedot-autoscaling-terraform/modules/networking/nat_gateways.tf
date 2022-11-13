# Resource: aws_nat_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway

resource "aws_nat_gateway" "gw1" {
  # The Allocation ID of the Elastic IP address for the gateway.
  allocation_id = aws_eip.nat1.id

  # The Subnet ID of the subnet in which to place the gateway.
  subnet_id = aws_subnet.pub_subnet_a.id

  # A map of tags to assign to the resource.
  tags = {
    Name = "nat-gateway-ap-southeast-1a${var.environment}"
  }
}

resource "aws_nat_gateway" "gw2" {
  # The Allocation ID of the Elastic IP address for the gateway.
  allocation_id = aws_eip.nat2.id

  # The Subnet ID of the subnet in which to place the gateway.
  subnet_id = aws_subnet.pub_subnet_b.id

  # A map of tags to assign to the resource.
  tags = {
    Name = "nat-gateway-ap-southeast-1b${var.environment}"
  }
}