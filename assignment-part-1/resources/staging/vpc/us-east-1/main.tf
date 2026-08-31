module "vpc" {
  source = "../../../../modules/vpc"
  count = length(var.vpc)
  vpc_cidr_block = var.vpc[count.index].vpc_cidr_block
  region = var.region
  public_subnet_cidrs = var.vpc[count.index].public_subnet_cidrs
  application_subnet_cidrs = var.vpc[count.index].application_subnet_cidrs
  db_subnet_cidrs = var.vpc[count.index].db_subnet_cidrs
  name = var.vpc[count.index].name
  environment = var.vpc[count.index].environment
}
