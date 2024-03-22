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

resource "aws_route_table_association" "public-ass" {
  for_each = var.public_subnets
  subnet_id      = aws_subnet.public_subnets[each.value["name"]].id
  route_table_id = aws_route_table.public-rt[each.value["name"]].id
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

resource "aws_route_table_association" "private-ass" {
  for_each = var.public_subnets
  subnet_id      = lookup(lookup(aws_subnet.private_subnets, each.value["name"], null), "id", null)
  route_table_id = lookup(lookup(aws_route_table.private-rt, each.value["name"], null), "id", null)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway_attachment" "example" {
  internet_gateway_id = aws_internet_gateway.example.id
  vpc_id              = aws_vpc.example.id
}

