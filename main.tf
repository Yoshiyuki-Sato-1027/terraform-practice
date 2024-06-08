provider "aws" {
  profile = "terraform"
  region = "us-east-1"
}

# ec2の起動
resource "aws_instance" "hello-world" {
  # イメージの指定
  ami           = "ami-0d191299f2822b1fa"
  instance_type = "t2.micro"
  tags = {
    Name: "Hello World"
  }
}