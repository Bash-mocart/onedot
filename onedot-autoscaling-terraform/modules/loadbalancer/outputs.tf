output "alb-dns" {
  value       = aws_lb.onedot_lb.dns_name
  description = "load balaner dns "
}

output "alb-target_group_arn" {
  value       = aws_lb_target_group.instance_target.arn
}
