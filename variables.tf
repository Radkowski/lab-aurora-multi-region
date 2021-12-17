
variable "DeploymentRegion_PRI" {
  default = "us-west-1"
  type    = string
}


variable "DeploymentRegion_SEC" {
  default = "us-east-1"
  type    = string
}


variable "DeploymentName" {
  default = "DB"
  type    = string
}


variable "VPCCIDR_PRI" {
  default = "10.0.0.0/16"
  type    = string
}

variable "VPCCIDR_SEC" {
  default = "172.16.0.0/16"
  type    = string
}
