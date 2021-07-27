output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets" {
  value = aws_subnet.caas_public[*].id
}
