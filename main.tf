module "networking" {
  source = "./modules/Network"
  environment          = "develop"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.0.0/24"]
  private_subnets_cidr = ["10.0.1.0/24"]
}
