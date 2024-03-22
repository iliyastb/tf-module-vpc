resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(
    var.tags,
    {Name = "${var.env}-vpc"}
  )
}

# public subnets
resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.main.id

  for_each = var.public_subnets
  cidr_block = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]
  tags = merge(
    var.tags,
    {Name = "${var.env}-${each.value["name"]}"}
  )
}

# public rt
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  for_each = var.public_subnets
  tags = merge(
    var.tags,
    {Name = "${var.env}-${each.value["name"]}"}
  )
}


# private subnets
resource "aws_subnet" "private_subnets" {
  vpc_id     = aws_vpc.main.id

  for_each = var.private_subnets
  cidr_block = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]
  tags = merge(
    var.tags,
    {Name = "${var.env}-${each.value["name"]}"}
  )
}

# private rt
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  for_each = var.private_subnets
  tags = merge(
    var.tags,
    {Name = "${var.env}-${each.value["name"]}"}
  )
}