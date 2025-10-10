variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the instance will be launched."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet for the EC2 instance."
}

variable "github_commit_sha" {
  type        = string
  description = "The commit SHA from GitHub Actions."
}

variable "github_is_snapshot" {
  type        = string
  description = "Indicates if the build is a snapshot."
}

variable "github_repository" {
  type        = string
  description = "The GitHub repository name."
}

variable "github_tag" {
  type        = string
  description = "The GitHub tag name, if applicable."
  default     = "snapshot"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy the AMI."
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "AWS region must be in the format 'xx-xxxx-x'."
  }
}
