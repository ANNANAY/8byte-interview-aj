variable "vpc" {
    type = map(
        object(
        {
            vpc_cidr_block = string
            public_subnet_cidrs = list(string)
            application_subnet_cidrs = list(string)
            db_subnet_cidrs = list(string)
            environment = string
            name = string
            cost_center = string
        }
    ))
}

variable "region" {
  type = string
}