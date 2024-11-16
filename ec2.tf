resource "aws_instance" "exapmle" {
  ami           = "ami-0d889f77081190db1"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}