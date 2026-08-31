variable "vpc_id" {
  description = "VPC ID where security groups are created"
  type        = string
}

variable "security_groups" {
  description = "Security groups and their rules"

  type = map(object({
    description = string

    ingress_rules = optional(list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string

      cidr_block = optional(string)
      source_sg  = optional(string)
    })), [])

    egress_rules = optional(list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string

      cidr_block     = optional(string)
      destination_sg = optional(string)
    })), [])

    tags = optional(map(string), {})
  }))
}