# aws_lb for nginx app access 
resource "aws_lb" "onedot_lb" {
  name               = "onedot-lb-${var.project}"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.sg_allow_80]
  subnets            = [
     var.pub_subnet_a,
     var.pub_subnet_b
  ]

  enable_deletion_protection = var.enable_deletion_protection #true

}
# listener for the alb
resource "aws_lb_listener" "alb-listener-80" {
  load_balancer_arn = aws_lb.onedot_lb.arn
  port              = var.lb_listener_port  
  protocol          = var.lb_listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_target.arn
  }
}

# target group for the alb
resource "aws_lb_target_group" "instance_target" {
  name     = "routing-requests-${var.project}"
  port     = var.lb_target_port
  protocol = var.lb_protocol 
  vpc_id   = var.vpc_id
  
}

