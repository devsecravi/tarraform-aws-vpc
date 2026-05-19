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

  tags = merge(local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public-${var.subnet_public[0]}"
        },
        var.subnet_public_tags
   )
}