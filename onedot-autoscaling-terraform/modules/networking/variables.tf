variable "vpc-cidr" {
    default = "192.168.0.0/16"
    type = string
}

variable "pub-subnet-cidr-a" {
    default = "192.168.0.0/18"
    type = string
}

variable "pub-subnet-cidr-b" {
    default = "192.168.64.0/18"
    type = string
}


variable "pri-subnet-cidr-a" {
    default = "192.168.128.0/18"
    type = string
}

variable "pri-subnet-cidr-b" {
    default = "192.168.192.0/18"
    type = string
    
}

variable "az-a" {
    type = string
}

variable "az-b" {
    type = string
}


variable "environment" {
  type    = string
}

variable "project" {
    type = string

}


