terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


data "aws_availability_zones" "AZs" {
  state = "available"
}



variable "DeploymentName" {}

variable "VPC_CIDR" {}
