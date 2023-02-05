resource "aws_vpc" "project_vpc" {
  cidr_block = "30.0.0.0/16"

  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = "30.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "prod-public-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = "30.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "prod-public-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "30.0.5.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "prod-private-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "30.0.6.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "prod-private-2"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "prod-igw"
  }
}

resource "aws_eip" "ip" {
  vpc = true

  tags = {
    Name = "nat-gw-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.public_subnet_1.id


  tags = {
    Name = "prod-nat-gw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "prod-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "prod-private-rt"
  }
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}