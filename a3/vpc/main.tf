data "aws_availability_zones" "available" {
    state = "available"
}

locals {
    vpc_mask = element(split("/", local.vpc_cidr_block), 1)
    vpc_cidr_block      = "10.0.0.0/16"
    subnet_mask         = "24"
}

resource "aws_vpc" "test_vpc" {
    cidr_block           = local.vpc_cidr_block
    enable_dns_hostnames = true

    tags = {
        Name = "test-vpc"
    }
}

resource "aws_internet_gateway" "test_igw" {
    vpc_id = aws_vpc.test_vpc.id

    tags = {
        Name = "test-igw"
    }
}

resource "aws_subnet" "test_public_subnet" {
    count             = 2
    vpc_id            = aws_vpc.test_vpc.id
    cidr_block        = cidrsubnet(local.vpc_cidr_block,local.subnet_mask - local.vpc_mask, count.index)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)

    tags = {
        Name = "test-public-subnet${count.index}"
    }
}

resource "aws_subnet" "test_private_subnet" {
    count             = 2
    vpc_id            = aws_vpc.test_vpc.id
    cidr_block        = cidrsubnet(local.vpc_cidr_block,local.subnet_mask - local.vpc_mask, count.index + 2)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)

    tags = {
        Name = "test-private-subnet${count.index}"
    }
}

resource "aws_route_table" "test_rt" {
    vpc_id = aws_vpc.test_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test_igw.id
    }

    tags = {
        Name = "test-public-route-table"
    }
}

resource "aws_route_table_association" "test_rta" {
    count          = 2
    subnet_id      = aws_subnet.test_public_subnet[count.index].id
    route_table_id = aws_route_table.test_rt.id
}