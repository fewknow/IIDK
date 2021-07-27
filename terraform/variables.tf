# https://www.terraform.io/docs/configuration/variables.html

# Project Config
variable "project_name" {
  default = "singualrity"
}


# AWS Config
variable "aws_profile" {
  default = "default"
}
variable "aws_region" {
  default = "us-east-2"
}

## VPC/Network Config
variable "cidr_block" {
  default = "10.10.10.0/24"
}
variable "public_subnet" {
  default = "10.10.10.0/27"
}
variable "private_subnet" {
  default = "10.10.10.32/27"
}
variable "azs_public" {
  default = "us-east-1a"
}
variable "azs_private" {
  default = "us-east-1b"
}

variable "azs_publics" {
  default = ["us-east-2a", "us-east-2b"]
}
variable "azs_privates" {
  default = ["us-east-2a", "us-east-2b"]
}
variable "private_subnets" {
  default = ["10.10.10.32/27", "10.10.10.64/27"]
}
variable "public_subnets" {
  default = ["10.10.10.96/27", "10.10.10.128/27"]
}
// variable "ssh_key" {
//     description = "SSH Access for the bastian host"
// }
# A tenancy option for instances launched into the VPC.
# Default is default, which makes your instances shared on the host.
# Using either of the other options (dedicated or host) costs at least $2/hr.
variable "instance_tenancy" {
  default = "default"
}


# Primary Subnet cidr_block within VPC
variable "subnet" {
  default = "10.20.0.0/24"
}
