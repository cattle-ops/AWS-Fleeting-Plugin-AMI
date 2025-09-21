variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the instance will be launched."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet for the EC2 instance."
}

variable "ingress_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the instance."
  validation {
    condition     = alltrue([for cidr in var.ingress_cidrs : can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", cidr))])
    error_message = "Each ingress CIDR must be a valid IPv4 CIDR block."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy the AMI."
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "AWS region must be in the format 'xx-xxxx-x'."
  }
}
