terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

resource "aws_instance" "EC2_MACHINE" {
  ami           = var.ubuntu_22_04_lts
  instance_type = var.instance_type
  key_name = var.key
  tags = {
    Name = var.ec2_name
  }
}

resource "aws_key_pair" "aws_key_pub" {
  key_name = var.key
  public_key = file("${var.key}.pub")


}

output "public_ip" {
  value = aws_instance.EC2_MACHINE.public_ip
}