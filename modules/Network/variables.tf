variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets_cidr" {
  type = list
}

variable "private_subnets_cidr" {
  type = list
}
