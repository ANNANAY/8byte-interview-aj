output "security_group_ids" {
  description = "Map of security group names to IDs"

  value = {
    for name, sg in aws_security_group.this :
    name => sg.id
  }
}