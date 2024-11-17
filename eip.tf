resource "aws_eip" "nat_gateway" {
  depends_on = [aws_internet_gateway.example]
  tags = {
    Name = "nat_gateway"
  }
}

