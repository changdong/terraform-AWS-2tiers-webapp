resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        #cidr_blocks = ["${var.private_subnet_cidr}"]
        cidr_blocks = ["${aws_subnet.terr_vpc_subnet_private.cidr_block}"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        #cidr_blocks = ["${var.private_subnet_cidr}"]
        cidr_blocks = ["${aws_subnet.terr_vpc_subnet_private.cidr_block}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        #cidr_blocks = ["${var.vpc_cidr}"]
        cidr_blocks = ["${aws_subnet.terr_vpc_subnet_private.cidr_block}"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.terr_vpc.id}"

    tags {
        Name = "Terr_NATSG"
    }
}

resource "aws_instance" "nat" {
    ami = "ami-0d087a6d" # Amazon Linux AMI 2016.03.0 x86_64 VPC NAT HVM EBS
    availability_zone = "${aws_subnet.terr_vpc_subnet_public.availability_zone}"
    instance_type = "m3.large"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.terr_vpc_subnet_public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "VPC NAT"
    }
}

resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}
