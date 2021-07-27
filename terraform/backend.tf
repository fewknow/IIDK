# terraform {
#   backend "remote" {
#     organization = "DoU-TFE"
#
#     workspaces {
#       prefix = "singularity-"
#     }
#   }
# }


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "default"
}



provider "local" {
  version = "~> 1.4"
}

provider "tls" {
  version = "~> 2.1"
}
