# VPC_EndPoints
VPC Endpoint Creation to use S3 Bucket Privately on Instance


# VPC ENDPOINTS for AMAZON S3:

* [PRIVATE INSTANCE] VPC, Subnet, PRIVATE_RT, Associate.
* Create ENDPOINT, associated with PRIVATE_RT.

* Create S3 (PUBLIC)

*  [JUMP SERVER] Using Same VPC, Attach IGW, RT, Create Public_Subnet

# Install CLI on Servers:

* Access S3 from JUMP
* Access S3 from PRIVATE

--------------------------------------------------------------------------------------

# Change the BUCKET POLICY for S3 (Make it Private):

--> {
   "Version": "2012-10-17",
   "Id": "Policy1415115909152",
   "Statement": [
     {
       "Sid": "Access-to-specific-VPCE-only",
       "Principal": "*",
       "Action": "s3:*",
       "Effect": "Deny",
       "Resource": ["arn:aws:s3:::examplebucket",
                    "arn:aws:s3:::examplebucket/*"],
       "Condition": {
         "StringNotEquals": {
           "aws:sourceVpce": "vpce-1a2b3c4d"
         }
       }
     }
   ]
}

--------------------------------------------------------------------------------------
