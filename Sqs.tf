resource "aws_sqs_queue" "terraform_queue" {
  name  = "terraform-example-queue"
  tags = {
    Environment = "production"
  }
}

resource "aws_vpc_endpoint" "sqs" {
  vpc_id            = "${aws_vpc.Endpoint_VPC.id}"
  service_name      = "com.amazonaws.eu-west-1.sqs"
  vpc_endpoint_type = "Interface"
  subnet_ids = ["${aws_subnet.Endpoint_Private.id}","${aws_subnet.Endpoint_Public.id}"]
  security_group_ids = [
    "${aws_security_group.my_pc.id}"
  ]

  private_dns_enabled = true
}