variable "aws_region" {
  description = "AWS region to create resources in"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.medium"
}
