# # Security Group Config
resource "aws_security_group" "caas_dev" {
  name        = var.project_name
  description = "Dev VPC for ${var.project_name}"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "SSH from Bastian"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP for EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP 8000 for ecs"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP 8000 for ecs"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "allow_ssh"
    Project = var.project_name
  }
}

# # Subnet Configuration
# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "caas_public" {
  count                   = 2
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = "true"
  availability_zone       = var.azs_publics[count.index]
  tags = {
    Name        = "${var.project_name}-public"
    Project     = var.project_name
    Environment = "Packaging"
  }
}

resource "aws_subnet" "caas_private" {
  count                   = 2
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.azs_privates[count.index]
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "${var.project_name}-private"
    Project     = var.project_name
    Environment = "Packaging"
  }
}

# Configure VPC Creation Module
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.44.0
module "vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "2.44.0"
  name             = "${var.project_name}-vpc"
  cidr             = var.cidr_block
  create_igw       = false
  instance_tenancy = var.instance_tenancy

  azs                  = ["${var.azs_public}", "${var.azs_private}"]
  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Terraform   = "true"
    Environment = "Packaging"
    Project     = var.project_name
  }

}

# Create Internet Gateway Config
resource "aws_internet_gateway" "caas" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Project     = var.project_name
    Environment = "Packaging"
  }
}


# Create Default Route

resource "aws_default_route_table" "caas" {
  default_route_table_id = module.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.caas.id
  }
  tags = {
    Project     = var.project_name
    Environment = "Packaging"
  }
}


resource "aws_instance" "web" {
  ami             = "ami-03a4e2b1d1f19317e"
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.caas_public[0].id
  security_groups = [aws_security_group.caas_dev.id]



  tags = {
    Name    = "fewknow"
    Project = "line decisions"
  }
}
