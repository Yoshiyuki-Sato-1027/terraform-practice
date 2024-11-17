# パブリックサブネット
resource "aws_subnet" "public_0" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # パブリックIPを自動で割り当てる
  availability_zone       = "ap-northeast-1a"
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true # パブリックIPを自動で割り当てる
  availability_zone       = "ap-northeast-1c"
}

# プライベートサブネット
resource "aws_subnet" "private_0" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.65.0/24"
  map_public_ip_on_launch = true # パブリックIPを自動で割り当てる
  availability_zone       = "ap-northeast-1a"
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.66.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
}

# 10.0.0.0/8の場合、ホスト部分が32-8=24で24bit、最初のアドレス10.0.0.0、最後のアドレス10.255.255.255
# 255は2の8乗
