provider "aws" {
  region = "ap-southeast-1"
}

module "lb-asg" {
  source        = "../modules/lb-asg"
  subnets       = ["subnet-030f4d3e2469fa7f4", "subnet-0035bce8603e8ec6a", "subnet-0d6dc766ed2c94e0e"]
  ami_id        = "ami-00d8fc944fb171e29"
  instance_type = "t2.small"
  key_name      = "jenkins-key"
  environment   = "dev"
  vpc_id        = "vpc-0f90cbe4cc8e97dcc"
}
