
resource "aws_vpc" "pipeline-test" {
    cidr_block = "10.0.0.0/24"

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "pipeline test VPC"
    }
}