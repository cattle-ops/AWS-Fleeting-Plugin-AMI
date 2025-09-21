variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ingress_cidrs" {
  type = list(string)
}

variable "aws_region" {
  type = string
}
