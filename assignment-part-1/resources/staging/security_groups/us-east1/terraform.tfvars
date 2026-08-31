security_groups = {

  alb = {
    description = "Security group for application load balancer"

    ingress_rules = [
      {
        description = "HTTP from internet"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        description = "HTTPS from internet"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    ]

    egress_rules = [
      {
        description = "Allow outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
      }
    ]

    tags = {
      tier = "public"
    }
  }

  application = {
    description = "Security group for application workloads"

    ingress_rules = [
      {
        description = "HTTP from ALB"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        source_sg   = "alb"
      }
    ]

    egress_rules = [
      {
        description = "Allow outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
      }
    ]

    tags = {
      tier = "application"
    }
  }

  database = {
    description = "Security group for PostgreSQL RDS"

    ingress_rules = [
      {
        description = "PostgreSQL from application"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        source_sg   = "application"
      }
    ]

    egress_rules = [
      {
        description = "Allow outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
      }
    ]

    tags = {
      tier = "database"
    }
  }
}