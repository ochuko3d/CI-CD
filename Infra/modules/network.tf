#VPC Creation

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags       = {
        Name = "${var.stack}-VPC"
    }
}

data "aws_availability_zones" "azs" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
# Private subnets
resource "aws_subnet" "private" {
  count             = length(var.privatesubnets)
  availability_zone = element(var.availability-zones, count.index)
  cidr_block        = var.privatesubnets[count.index]
  vpc_id            = aws_vpc.main.id
  
}

# Public subnets
resource "aws_subnet" "public" {
  count             = length(var.publicsubnets)
  availability_zone = element(var.availability-zones, count.index)
  cidr_block        = var.publicsubnets[count.index]
  vpc_id            = aws_vpc.main.id
 
}


# EIPs for NAT gateways
resource "aws_eip" "eips" {
  count = length(var.publicsubnets)
  vpc   = true
 
}

# Put a NAT gateways in each public subnet
resource "aws_nat_gateway" "nat" {
  count         = length(var.publicsubnets)
  allocation_id = element(aws_eip.eips.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)


  depends_on = [aws_internet_gateway.gw]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.stack}-IGW"
  }
}

# Create publc route tables
resource "aws_route_table" "public" {
  count  = length(var.availability-zones)
  vpc_id = aws_vpc.main.id


}

# Create private route tables
resource "aws_route_table" "private" {
  count  = length(var.availability-zones)
  vpc_id = aws_vpc.main.id


}

# Add default route to the public route table to allow traffic out to the Internet via Internet gateways
resource "aws_route" "public-default" {
  count                  = length(aws_route_table.public[*])
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  route_table_id         = aws_route_table.public[count.index].id
}

# Add default route to the private route tables to allow traffic out to the Internet via NAT gateways
resource "aws_route" "private-default" {
  count                  = length(aws_route_table.private[*])
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
  route_table_id         = aws_route_table.private[count.index].id
}

# Associate routing tables to appropriate subnets
resource "aws_route_table_association" "public" {
  count          = length(var.publicsubnets)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.privatesubnets)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}

resource "aws_vpc_dhcp_options" "ecs" {
  domain_name          = "${var.family}"
  domain_name_servers  = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.ecs.id
}
