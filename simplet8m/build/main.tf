provider "aws" {
  access_key = "-"
  secret_key = "-"
  region = "ap-southeast-1" 
}

resource "aws_instance" "example" {
  ami           = "ami-0b2e3ee546433ee34" 
  instance_type = "t2.micro"
  subnet_id = "subnet-078d82966f0a560a0"
}

