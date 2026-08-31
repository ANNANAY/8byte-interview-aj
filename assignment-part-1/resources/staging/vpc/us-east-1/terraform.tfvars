vpc = [
    {
    vpc_cidr_block = "10.0.0.0/16"
    public_subnet_cidrs = ["10.0.1.0/24","10.0.2.0/24"]
    application_subnet_cidrs = ["10.0.11.0/24","10.0.12.0/24"]
    db_subnet_cidrs = ["10.0.31.0/24","10.0.32.0/24"]
    # Tags
    environment = "Staging"
    name = "8byte-terraform-vpc-assignment-aj"
    cost_center = "12345"
    }
]

region = "us-east-1"