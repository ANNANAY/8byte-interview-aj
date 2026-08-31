data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    2
  )
}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  region     = var.region
  tags = {
    name        = "${var.name}-${var.environment}"
    environment = var.environment
  }
}


resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  vpc_id                  = aws_vpc.main.id
  region                  = var.region
  map_public_ip_on_launch = true
  tags = {
    name        = "${var.name}-${var.environment}-public-${count.index}"
    environment = "${var.environment}"
  }
}


resource "aws_subnet" "application_subnet" {
  count             = length(var.application_subnet_cidrs)
  cidr_block        = var.application_subnet_cidrs[count.index]
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  region            = var.region
  tags = {
    name        = "${var.name}-${var.environment}-application-${count.index}"
    environment = "${var.environment}"
  }
}


resource "aws_subnet" "db_private_subnet" {
  count             = length(var.db_subnet_cidrs)
  cidr_block        = var.db_subnet_cidrs[count.index]
  vpc_id            = aws_vpc.main.id
  region            = var.region
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    name        = "${var.name}-${var.environment}-db-${count.index}"
    environment = "${var.environment}"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  region = var.region
  tags = {
    name        = "${var.name}-${var.environment}-igw"
    environment = var.environment
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  region = var.region
  tags = {
    name        = "${var.name}-${var.environment}-public-rt"
    environment = var.environment
  }
}


resource "aws_route" "public_internet" {
  region                 = var.region
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    name        = "${var.name}-${var.environment}-nat-eip"
    environment = var.environment
  }
}


resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    name        = "${var.name}-${var.environment}-nat-gw"
    environment = var.environment
  }
  depends_on = [
    aws_internet_gateway.main
  ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  region = var.region
  tags = {
    name        = "${var.name}-${var.environment}-private-rt"
    environment = var.environment
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.application_subnet_cidrs)
  subnet_id      = aws_subnet.application_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = {
    name        = "${var.name}-${var.environment}-database-rt"
    environment = var.environment
  }
}

resource "aws_route_table_association" "database" {
  count = length(var.db_subnet_cidrs)
  subnet_id      = aws_subnet.db_private_subnet[count.index].id
  route_table_id = aws_route_table.database.id
}

