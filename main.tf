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
        }
  )
}