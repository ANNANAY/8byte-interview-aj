module "security_groups" {
  source = "./modules/security-group"

  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
}