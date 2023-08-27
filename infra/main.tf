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

resource "aws_launch_template" "EC2_template" {
  image_id      = var.ubuntu_22_04_lts
  instance_type = var.instance_type
  key_name      = var.key
  tags = {
    Name = var.ec2_name
  }
  security_group_names = [ var.security_group_name ]
  user_data = filebase64("ansible.sh")
}

#resource "aws_instance" "EC2_MACHINE" {
#  launch_template {
#    id = aws_launch_template.EC2_template.id
#    version = "$Latest"
#  }
#}

resource "aws_key_pair" "aws_key_pub" {
  key_name   = var.key
  public_key = file("${var.key}.pub")

}

resource "aws_autoscaling_group" "group" {
  name = var.group_name
  max_size = var.max_ec2
  min_size = var.min_ec2
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  launch_template {
    id = aws_launch_template.EC2_template.id
    version = "$Latest"
  }
}

resource "aws_default_subnet" "subnet_01" {
  availability_zone = "${var.aws_region}a"
}

resource "aws_default_subnet" "subnet_02" {
  availability_zone = "${var.aws_region}b"
}