resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = each.key
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = each.key
    },
    each.value.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = {
    for rule in local.ingress_rules :
    rule.key => rule
  }

  security_group_id = aws_security_group.this[each.value.security_group].id

  description = each.value.description
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv4 = each.value.cidr_block

  referenced_security_group_id = each.value.source_sg != null ? (
    aws_security_group.this[each.value.source_sg].id
  ) : null
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = {
    for rule in local.egress_rules :
    rule.key => rule
  }

  security_group_id = aws_security_group.this[each.value.security_group].id

  description = each.value.description
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv4 = each.value.cidr_block

  referenced_security_group_id = each.value.destination_sg != null ? (
    aws_security_group.this[each.value.destination_sg].id
  ) : null
}

locals {
  ingress_rules = flatten([
    for sg_name, sg in var.security_groups : [
      for index, rule in sg.ingress_rules : {
        key            = "${sg_name}-ingress-${index}"
        security_group = sg_name
        description    = rule.description
        from_port      = rule.from_port
        to_port        = rule.to_port
        protocol       = rule.protocol
        cidr_block     = rule.cidr_block
        source_sg      = rule.source_sg
      }
    ]
  ])

  egress_rules = flatten([
    for sg_name, sg in var.security_groups : [
      for index, rule in sg.egress_rules : {
        key             = "${sg_name}-egress-${index}"
        security_group  = sg_name
        description     = rule.description
        from_port       = rule.from_port
        to_port         = rule.to_port
        protocol        = rule.protocol
        cidr_block      = rule.cidr_block
        destination_sg  = rule.destination_sg
      }
    ]
  ])
}