# Create a VPC to launch our instances into
resource "aws_vpc" "terr_vpc" {
  cidr_block = "10.222.0.0/16"

  tags {
    Name = "terraform_vpc"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "terr_gw" {
  vpc_id = "${aws_vpc.terr_vpc.id}"

  tags {
    Name = "Terraform_Gateway"
  }

}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.terr_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.terr_gw.id}"
}

