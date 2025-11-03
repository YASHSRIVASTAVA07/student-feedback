variable "region" {
  default = "eu-north-1"
}

variable "ami_id" {
  # Example Ubuntu 24.04 AMI for eu-north-1
  default = "ami-08116b9957a259459"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "vpc_id" {
  default = "vpc-05196f9f7fcef30c8"
}

variable "subnet_id" {
  # Use your own public subnet ID
  default = "subnet-0d10e4c32b05d3c26"
}
