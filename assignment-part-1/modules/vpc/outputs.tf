# ---------------------------------------------------------
# VPC
# ---------------------------------------------------------

output "vpc_id" {
  description = "ID of the VPC"

  value = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"

  value = aws_vpc.main.cidr_block
}

# ---------------------------------------------------------
# Public Subnets
# ---------------------------------------------------------

output "public_subnet_ids" {
  description = "IDs of the public subnets"

  value = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"

  value = aws_subnet.public[*].cidr_block
}


# ---------------------------------------------------------
# Private Subnets
# ---------------------------------------------------------

output "private_subnet_ids" {
  description = "IDs of the private subnets"

  value = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"

  value = aws_subnet.private[*].cidr_block
}


# ---------------------------------------------------------
# Internet Gateway
# ---------------------------------------------------------

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}


# ---------------------------------------------------------
# NAT Gateway
# ---------------------------------------------------------

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_eip" {
  description = "Elastic IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}
