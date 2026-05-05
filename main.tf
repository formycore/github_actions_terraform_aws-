# 1. Configure the AWS Provider
provider "aws" {
  region = "ap-south-1" # Change to your preferred region
}

# 2. Define the EC2 Instance
resource "aws_instance" "example_server" {
  ami           = "ami-07a00cf47dbbc844c" # ubuntu 20.04 LTS in ap-south-1
  instance_type = "t3.micro"             # Free-tier eligible type

  tags = {
    Name = "TerraformExampleInstance"
  }
}
