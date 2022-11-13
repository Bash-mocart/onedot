variable "environment" {
  type = string
}
variable "pub_subnet_a" {
    type = string
  
}

variable "pub_subnet_b" {
    type = string
  
}
variable "sg_allow_80" {
    type = string
  
}
variable "vpc_id" {
    type = string
  
}

variable "lb_listener_port" {
  description = "lb_listener_port"
  type        = number
  default     = 80
}

variable "lb_listener_protocol" {
  description = "lb_listener_protocol HTTP, TCP, TLS"
  type        = string
  default     = "HTTP"
}

variable "enable_deletion_protection" {
  description = "enable_deletion_protection true or false"
  type        = bool
  default     = false
}

variable "lb_target_port" {
  description = "lb_target_port"
  type        = number
  default     = 8888
}

variable "lb_protocol" {
  description = "lb_protocol HTTP (ALB) or TCP (NLB)"
  type        = string
  default     = "HTTP"
}

variable "internal" {
    type = string
  
}

variable "project" {
    type = string

}

variable "load_balancer_type" {
    type = string
  
}



