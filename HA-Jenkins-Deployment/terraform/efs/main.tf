provider "aws" {
  region = "ap-southeast-1"
}

module "efs_module" {
  source     = "../modules/efs"
  vpc_id     = "vpc-0f90cbe4cc8e97dcc"
  subnet_ids = ["subnet-030f4d3e2469fa7f4", "subnet-0035bce8603e8ec6a", "subnet-0d6dc766ed2c94e0e"]
}
