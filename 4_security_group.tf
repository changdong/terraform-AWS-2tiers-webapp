# Our default security group to access the instances over SSH and HTTP
/*
 web
*/

resource "aws_security_group" "httpsshSG" {
  name        = "terraform_httpsshSG"
  description = "terraform httpsshSG"
  vpc_id      = "${aws_vpc.terr_vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.222.0.0/16", "162.246.216.28/32"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
  DB Servers
*/
resource "aws_security_group" "dbSG" {
    name = "terraform_dbSG"
    description = "Allow incoming database connections."
    vpc_id      = "${aws_vpc.terr_vpc.id}"

    ingress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.httpsshSG.id}"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.222.0.0/16"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["10.222.0.0/16"]
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

    tags {
        Name = "DBSecurityGroup"
    }
}

