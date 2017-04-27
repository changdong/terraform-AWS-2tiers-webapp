variable "public_key_path" {
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  default     = "~/.ssh/id_rsa"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default     = "terraform_key"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-1"
}

# Ubuntu Precise 16.04 LTS (x64)
variable "aws_amis" {
  type = "map"
  default = {
    us-east-1 = "ami-7cb0246a"
    us-east-2 = "ami-6689ad03"
    us-west-1 = "ami-d7f8ddb7"
    us-west-2 = "ami-e8d84a88"   
  }
}
