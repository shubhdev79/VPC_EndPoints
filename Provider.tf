provider "aws"{
	region  = "eu-west-1"
}

resource "aws_vpc" "Endpoint_VPC" {
		cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
			tags = {
			Name = "Endpoint_VPC"
			}
		}
		
resource "aws_internet_gateway" "Endpoint_IGW" {
  vpc_id = "${aws_vpc.Endpoint_VPC.id}"

  tags = {
    Name = "Endpoint_IGW"
  }
}        

resource "aws_s3_bucket" "Endpoint_S3" {
  bucket = "shubam-endpoint-s3"
   acl    = "private"

  tags = {
    Name = "shubam-endpoint-s3"
    
  }
}

resource "aws_subnet" "Endpoint_Public" {
vpc_id = "${aws_vpc.Endpoint_VPC.id}" 
cidr_block = "10.0.1.0/24"
map_public_ip_on_launch = true
#availability_zone = "${element(var.availability_zone_names, count.index)}" 
tags = {   
	    Name = "Endpoint_Public"
		}
}


resource "aws_subnet" "Endpoint_Private" {
vpc_id = "${aws_vpc.Endpoint_VPC.id}" 
cidr_block = "10.0.2.0/24"
map_public_ip_on_launch = false
#availability_zone = "${element(var.availability_zone_names, count.index)}" 
tags = {   
	    Name = "Endpoint_Private"
		}
}

resource "aws_route_table" "Endpoint_PubRT"{
vpc_id = "${aws_vpc.Endpoint_VPC.id}"

route{
cidr_block = "0.0.0.0/0"
gateway_id = "${aws_internet_gateway.Endpoint_IGW.id}"
}

tags = {
Name = "Endpoint_PubRT"
}

#depends_on = ["aws_vpc.mgt_vpc","aws_internet_gateway.Mgt-IGW"]
}

resource "aws_route_table_association" "Endpoint_PublicSubnet_Association" {
  subnet_id      = "${aws_subnet.Endpoint_Public.id}"
  route_table_id = "${aws_route_table.Endpoint_PubRT.id}"
}

resource "aws_route_table" "Endpoint_PriRT" {
vpc_id = "${aws_vpc.Endpoint_VPC.id}"

tags = {
Name = "Endpoint_PriRT"
}
depends_on = ["aws_vpc.Endpoint_VPC"]

}

resource "aws_route_table_association" "Endpoint_PrivateSubnet_Association" {
  #count = var.number_of_subnets_app_tier
  subnet_id      = "${aws_subnet.Endpoint_Private.id}"
  route_table_id = "${aws_route_table.Endpoint_PriRT.id}"
}

resource "aws_vpc_endpoint" "Endpoint_S3" {
  vpc_id       = "${aws_vpc.Endpoint_VPC.id}"
  service_name = "com.amazonaws.eu-west-1.s3"

  tags = {
    Name = "Endpoint_S3"
  }
}

resource "aws_vpc_endpoint_route_table_association" "Endpoint_S3_association" {
  route_table_id  = "${aws_route_table.Endpoint_PriRT.id}"
  vpc_endpoint_id = "${aws_vpc_endpoint.Endpoint_S3.id}"
}

resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.Endpoint_S3.id}"

  policy = <<POLICY
{
   "Version": "2012-10-17",
   "Id": "Policy1415115909152",
   "Statement": [
     {
       "Sid": "Access-to-specific-VPCE-only",
       "Principal": "*",
       "Action": "s3:*",
       "Effect": "Allow",
       "Resource": ["arn:aws:s3:::shubam-endpoint-s3",
                    "arn:aws:s3:::shubam-endpoint-s3/*"],
       "Condition": {
         "StringNotEquals": {
           "aws:sourceVpce": "vpce-0c05264edec5ad40b"
         }
       }
     }
   ]
}
POLICY
}