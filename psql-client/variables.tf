terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "DeploymentName" {}
variable "VPCID" {}
variable "subnet_id" {}
