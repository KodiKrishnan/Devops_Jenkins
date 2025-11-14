provider "aws" {
  region = "ap-southeast-1"
}

module "ec2_instance" {
  source         = "../modules/ec2"
  instance_name  = "jenkins-agent"
  ami_id         = "ami-09351568b7bf0df0b"
  instance_type  = "t2.small"
  key_name       = "jenkins-key"
  subnet_ids     = ["subnet-030f4d3e2469fa7f4", "subnet-0035bce8603e8ec6a", "subnet-0d6dc766ed2c94e0e"]
  instance_count = 1
}
