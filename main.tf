resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = local.gw_final_tags
}

resource "aws_subnet" "public" {
  count = length(var.subnet_public)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_public[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
        },
        var.subnet_public_tags
   )
}

resource "aws_subnet" "private" {
  count = length(var.subnet_private)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_private[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
        },
        var.subnet_private_tags
   )
}

resource "aws_subnet" "database" {
  count = length(var.subnet_database)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_database[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(local.common_tags,
        {
            Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
        },
        var.subnet_database_tags
   )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        {
           Name = "${var.project}-${var.environment}-public"
        },
        var.aw_route_table_public
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        {
           Name = "${var.project}-${var.environment}-private"
        },
        var.aw_route_table_private
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        {
           Name = "${var.project}-${var.environment}-database"
        },
        var.aw_route_table_database
  )
}

resource "aws_route" "public" {
  count = length(var.aw_route_table_public)
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id= aws_internet_gateway.gw.id
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  tags = merge(
        local.common_tags,
        {
           Name = "{var.project}-{var.environment}-nat"
        },
        var.eip_nat_tags
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = marge(
        local.common_tags,
        {
            Name = "{var.project}-{var.environment}"
        },
        var.nat_gateway_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "private" {
  count = length(var.aw_route_table_private)
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id= aws_internet_gateway.gw.id
}

resource "aws_route" "database" {
  count = length(var.aw_route_table_database)
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id= aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  count = length(var.subnet_public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.subnet_private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.subnet_database)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

