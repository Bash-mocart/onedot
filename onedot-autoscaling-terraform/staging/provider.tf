# aws credentials set up in terraform workspace env variables
provider "aws" {
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.4.0"
    }
  }
  cloud {
    organization = "onedot-infra"

    workspaces {
      name = "onedot-stage"
    }
  }

  # using terraform cloud as backend 
}


# autoscaling module containing launch template, autoscaling group, autoscaling group attachment to the alb
module "autoscaling" {
  source                  = "../modules/autoscaling/"
  environment             = terraform.workspace
  pri_subnet_a               = module.networking.pri_subnet_id_a
  pri_subnet_b             = module.networking.pri_subnet_id_b
  aws_lb_target_group_arn = module.loadbalancer.alb-target_group_arn
  sg_allow_8888           = module.networking.sg_allow_8888
  max_size                = 2
  min_size                = 2
  desired_capacity        = 2
  asg_health_check_type   = "ELB"
  project                 = var.project
}
# load balancer  module containing alb, alb listener, alb listener rule, target group
module "loadbalancer" {
  source             = "../modules/loadbalancer/"
  environment        = terraform.workspace
  sg_allow_80     = module.networking.sg_allow_80
  pub_subnet_a          = module.networking.pub_subnet_id_a
  pub_subnet_b        = module.networking.pub_subnet_id_b
  vpc_id             = module.networking.vpc_id
  internal           = false
  load_balancer_type = "application"
  project            = var.project

}
# networking module containing vpc, 2 public subnets, s3 bucket, security groups, routing tables, internet gateway
module "networking" {
  source      = "../modules/networking/"
  environment = "production"
  project     = var.project
  az-a = "ap-southeast-1a"
  az-b = "ap-southeast-1b"
}

variable "project" {
  type    = string
  default = "onedot-app"

}

# outputting alb dns hostname 
output "alb_dns" {
  value = module.loadbalancer.alb-dns
}
# outputting instances_tags
output "instances_tags" {
  value = module.autoscaling.instances_tags
}