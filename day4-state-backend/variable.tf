variable "ami_id" {
  type        = string
  description = "The AMI ID to launch the EC2 instance"
  default     = "ami-0d53cc9bd365ad65b"
}

variable "instance_type" {
  type        = string
  description = "The size of the instance (e.g., t3.micro or t2.micro)"
  default     = "t3.micro" # Updated to t3.micro to avoid the Free Tier error
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID where the instance will deploy"
  default     = "subnet-0b40a8759b4430056"
}
