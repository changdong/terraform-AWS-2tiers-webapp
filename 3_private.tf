# Create a subnet to launch our instances into
resource "aws_subnet" "terr_vpc_subnet_private" {
  vpc_id                  = "${aws_vpc.terr_vpc.id}"
  cidr_block              = "10.222.2.0/24"
  map_public_ip_on_launch = false

  tags {
    Name = "terr_vpc_subnet_private"
  }
}

resource "aws_route_table" "route_table_private" {
    vpc_id = "${aws_vpc.terr_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "rt-association-private" {
    subnet_id = "${aws_subnet.terr_vpc_subnet_private.id}"
    route_table_id = "${aws_route_table.route_table_private.id}"
}
