provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "{var.AWS_SECRET_KEY}"
  region = "${var.AWS_RESION}"
}

resource "aws_instance" "example" {
  ami = "ami-79815217"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.mykey.key_name}"
  connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("$var.PATH_TO_PRIVATE_KEY}")}"
  }
  tages = {
    Name = "My Instance"
  }
}

resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = "$file("${var.PATH_TO_PUBLIC_KEY}")}"
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_RESION" {
  default = "ap-northeast-2"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

