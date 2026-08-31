variable "vpc_cidr_block" {
  type = string
}

variable "region" {
  type = string
}



variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "application_subnet_cidrs" {
  description = "CIDR blocks for application subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
}

# tags 
variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cost_center" {
  type = string
}