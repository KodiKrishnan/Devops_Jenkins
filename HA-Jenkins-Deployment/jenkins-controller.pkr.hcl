packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.0.0"
    }
  }
}

variable "ami_id" {
  type    = string
  default = "ami-0827b3068f1548bf6"
}

variable "efs_mount_point" {
  type    = string
  default = ""
}

locals {
  app_name = "jenkins-controller-updated"
}

source "amazon-ebs" "jenkins" {
  ami_name           = local.app_name
  instance_type      = "t2.micro"
  region             = "ap-southeast-1"
  availability_zone  = "ap-southeast-1b"
  source_ami         = var.ami_id
  ssh_username       = "ubuntu"
  tags = {
    Env  = "dev"
    Name = local.app_name
  }
}

build {
  sources = ["source.amazon-ebs.jenkins"]

  provisioner "ansible" {
    playbook_file   = "ansible/jenkins-controller.yaml"
    user            = "ubuntu"
    extra_arguments = [
      "--extra-vars", "ami-id=${var.ami_id} efs_mount_point=${var.efs_mount_point}",
      "--scp-extra-args", "'-O'",
      "--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
