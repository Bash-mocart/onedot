# allows 8080 inbound traffic 
resource "aws_security_group" "allow_8888" {
  name        = "allow-8888-${var.environment}"
  description = "Allow inbound traffic on port 8888"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "security group instance"
  }
}



resource "aws_security_group_rule" "allow_inbound_8888" {
  description              = "Allow port 8080"
  from_port                = 8888
  protocol                 =  "tcp"
  security_group_id        = aws_security_group.allow_8888.id
  cidr_blocks              = ["0.0.0.0/0"]
  
  to_port                  = 8888
  type                     = "ingress"
}
# outbound traffic
resource "aws_security_group_rule" "outgoing_asg" {
  description              = "Allow all outgoing"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.allow_8888.id
  cidr_blocks              = ["0.0.0.0/0"]
  to_port                  = 0
  type                     = "egress"
}

# allows 80 inbound traffic 
resource "aws_security_group" "allow_80" {
  name        = "allow-80-${var.environment}"
  description = "Allow inbound traffic on port 8888"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "security group instance"
  }
}



resource "aws_security_group_rule" "allow_inbound_80" {
  description              = "Allow port 8080"
  from_port                = 80
  protocol                 =  "tcp"
  security_group_id        = aws_security_group.allow_80.id
  cidr_blocks              = ["0.0.0.0/0"]
  
  to_port                  = 80
  type                     = "ingress"
}
# outbound traffic
resource "aws_security_group_rule" "outgoing_lb" {
  description              = "Allow all outgoing"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.allow_80.id
  cidr_blocks              = ["0.0.0.0/0"]
  to_port                  = 0
  type                     = "egress"
}