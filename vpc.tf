resource "aws_vpc" "my_vpc"{
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        name = "my_vpc"
    }
}

resource "aws_subnet" "public_subnet"{
    vpc_id = aws_vpc.my_vpc.id
    count = length(var.public_cidr_block)
    cidr_block = element(var.public_cidr_block, count.index)
    avalability_zone = element(var.avalability_zone, count.index)
    map_public_ip_on_launch = true
    tags = {
        name = "public_subnet"
    }
}
resource "aws_subnet" "private_subnet"{
    vpc_id = aws_vpc.my_vpc.id
    count = length(var.private_cidr_block)
    cidr_block = element(var.private_cidr_block, count.index)
    avalability_zone = element(var.avalability_zone, count.index)
    
    tags = {
        name = "private_subnet"
    }
}

resource "aws_internet_gateway" "my_gw"{
vpc_id = aws_vpc.my_vpc.id
tags = {
    name = "myGW"
}
}

resource "aws_route_table" "publicrt"{
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.id
    }
    tags = {
        name = "public_rt"
    }
}
resource "aws_route_table" "privatert"{
    vpc_id = aws_vpc.my_vpc.id
    route = []
    tags = {
        name = "publiuc-rt"

    }
}

resource "aws_route_table_association" "publicass" {
    count = length(var.public_cidr_block)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "privateass"{
    count = length(var.private_cidr_block)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.privatert.id
    depends_on = [aws_nat_gateway.nat]
}

resource "aws_eip" "eip_nat"{
    domain = "vpc"
}

resource "aws_nat_gateway" "nat"{
    allocation_id = aws_eip.eip_nat.id
    subnet_id = aws_subnet.public[0].id
    tags = {
        name = "natgatway"
    }
    depends_on = aws_internet_gateway.my_gw
}
resource "aws_route" "nat_route"{
    route_table_id    = aws_route_table.publicrt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
    depends_on = [aws_route_table.privatert]
}
