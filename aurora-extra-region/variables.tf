terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "DeploymentName" {}
variable "PRIV-PRI-SUBNETSID" {}
variable "CLUSTERENGINE" {}
variable "CLUSTERENGINEVERSION" {}
variable "GLOBALCLUSTERID" {}
