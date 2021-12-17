
module "MAIN-VPC-PRI" {
  source         = "./main-vpc"
  DeploymentName = join("", [var.DeploymentName, "-", var.DeploymentRegion_PRI])
  VPC_CIDR       = var.VPCCIDR_PRI
}


module "MAIN-VPC-SEC" {
  providers = {
    aws = aws.spoke_region
  }
  source         = "./main-vpc"
  DeploymentName = join("", [var.DeploymentName, "-", var.DeploymentRegion_SEC])
  VPC_CIDR       = var.VPCCIDR_SEC
}


module "MAIN-VPC-PRI-CLIENT" {
  depends_on     = [module.MAIN-VPC-PRI, module.MAIN-VPC-SEC]
  source         = "./psql-client"
  DeploymentName = join("", [var.DeploymentName, "-", var.DeploymentRegion_PRI])
  VPCID          = module.MAIN-VPC-PRI.VPCID
  subnet_id      = module.MAIN-VPC-PRI.FIRSTPUBSUBNETID
}


module "MAIN-VPC-SEC-CLIENT" {
  depends_on = [module.MAIN-VPC-PRI, module.MAIN-VPC-SEC]
  providers = {
    aws = aws.spoke_region
  }
  source         = "./psql-client"
  DeploymentName = join("", [var.DeploymentName, "-", var.DeploymentRegion_SEC])
  VPCID          = module.MAIN-VPC-SEC.VPCID
  subnet_id      = module.MAIN-VPC-SEC.FIRSTPUBSUBNETID
}


module "AURORA-MAIN" {
  source             = "./aurora-global"
  depends_on         = [module.MAIN-VPC-PRI]
  DeploymentName     = join("", [var.DeploymentName, "-", var.DeploymentRegion_PRI])
  PRIV-PRI-SUBNETSID = module.MAIN-VPC-PRI.PRIVSUBNETSID
}


module "AURORA-REGIONAL" {
  source = "./aurora-extra-region"
  providers = {
    aws = aws.spoke_region
  }
  depends_on           = [module.MAIN-VPC-SEC, module.AURORA-MAIN]
  DeploymentName       = join("", [var.DeploymentName, "-", var.DeploymentRegion_SEC])
  PRIV-PRI-SUBNETSID   = module.MAIN-VPC-SEC.PRIVSUBNETSID
  CLUSTERENGINE        = module.AURORA-MAIN.CLUSTERENGINE
  CLUSTERENGINEVERSION = module.AURORA-MAIN.CLUSTERENGINEVERSION
  GLOBALCLUSTERID      = module.AURORA-MAIN.GLOBALCLUSTERID
}
