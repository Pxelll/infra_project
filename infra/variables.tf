variable "aws_region" {
  type = string
}
variable "key" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "ec2_name" {
  type = string
}
variable "ubuntu_22_04_lts" {
  type    = string
  default = "ami-053b0d53c279acc90"
}
variable "security_group_name" {
  type = string
}
variable "group_name" {
  type = string
}
variable "max_ec2" {
  type = number
}
variable "min_ec2" {
  type = number
}
variable "production" {
  type = bool
}