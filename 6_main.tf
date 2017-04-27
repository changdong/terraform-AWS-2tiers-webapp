# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "web" {
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}" 
    timeout = "2m"
    agent = false
  }

  instance_type = "m1.small"

  ami = "${lookup(var.aws_amis, var.aws_region)}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.httpsshSG.id}"]
  subnet_id = "${aws_subnet.terr_vpc_subnet_public.id}"

  tags {
    Name = "WEB"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y upgrade",
      "sudo apt-get -y install nginx",
      "sudo service nginx start"
    ]
  }
}

resource "aws_instance" "redis" {
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    timeout = "2m"
    agent = false
  }


  instance_type = "m1.small"

  ami = "${lookup(var.aws_amis, var.aws_region)}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.dbSG.id}"]
  subnet_id = "${aws_subnet.terr_vpc_subnet_private.id}"
  source_dest_check = false

  tags {
    Name = "Redis"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y upgrade"
    ]
  }
}

