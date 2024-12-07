resource "aws_vpc" "tfer--vpc-006296b1ba7c49a34" {
  assign_generated_ipv6_cidr_block     = "false"
  cidr_block                           = "172.31.0.0/16"
  enable_dns_hostnames                 = "true"
  enable_dns_support                   = "true"
  enable_network_address_usage_metrics = "false"
  instance_tenancy                     = "default"
  ipv6_netmask_length                  = "0"
}

resource "aws_vpc" "tfer--vpc-0bc3fdcbd748ad09c" {
  assign_generated_ipv6_cidr_block     = "true"
  cidr_block                           = "10.0.0.0/16"
  enable_dns_hostnames                 = "true"
  enable_dns_support                   = "true"
  enable_network_address_usage_metrics = "false"
  instance_tenancy                     = "default"
  ipv6_cidr_block                      = "2406:da14:17:9900::/56"
  ipv6_cidr_block_network_border_group = "ap-northeast-1"
  ipv6_netmask_length                  = "0"

  tags = {
    Name = "ricepot_creater-vpc"
  }

  tags_all = {
    Name = "ricepot_creater-vpc"
  }
}

resource "aws_vpc" "tfer--vpc-0bef3af9dea150db7" {
  assign_generated_ipv6_cidr_block     = "false"
  cidr_block                           = "192.168.0.0/16"
  enable_dns_hostnames                 = "false"
  enable_dns_support                   = "true"
  enable_network_address_usage_metrics = "false"
  instance_tenancy                     = "default"
  ipv6_netmask_length                  = "0"
}
