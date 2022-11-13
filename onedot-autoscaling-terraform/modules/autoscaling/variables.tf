variable "key_name" {
  type    = string
  default = "docker-compose"
}


variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "environment" {
  type    = string
}

variable "pri_subnet_a" {
    type = string
  
}

variable "pri_subnet_b" {
    type = string
  
}

variable "aws_lb_target_group_arn" {
    type = string
  
}

variable "sg_allow_8888" {
    type = string
  
}


variable "max_size" {
    type = number

}
variable "min_size" {
    type = number

}

variable "desired_capacity" {
    type = number

}
variable "asg_health_check_type" {
    type = string

}

variable "project" {
    type = string

}



