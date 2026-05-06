# multiple region terraform deployment
provider "aws"{
	alias = "first_region"
	region = "us-east-1"
}
provider "aws" {
	alias = "us-west-2"
	region = "us-west-2"
}
resource "aws_instance" "example" {
	ami = "ami-0eb38b817b93460ac"
	instance_type = "t3.micro"
	provider = "aws.first_region"
}

resource "aws_instance" "ex" {
	ami = "ami-0d43f0bb92e485897"
	instance_type = "t3.micro"
	provider = "aws.us-west-2"
}
