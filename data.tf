#------------------------------------------------------
# Role for deployment of resources
#------------------------------------------------------
data "aws_iam_role" "cicd-deploment" {
name = "${app-id}-cicd-deploment"
}
#------------------------------------------------------
# Fething exisitng VPC  where ec2 will deploy
#------------------------------------------------------
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]     #dummy vpc-name replace with your correct one
  }
  filter {
    name   = "vpc-id"
    values = ["vpc-1234567890abcdef0"]  #dummy vpc-id replace with yuor correct one
  }
}
#------------------------------------------------------
# exsiting  private subnets in vpc 
#------------------------------------------------------
data "aws_subnets" "vpc-exisitng-private-subnets" {
filter {
    name   = "vpc-id"
    values = [dat.aws_vpc.existing_vpc]
  }
}

#------------------------------------------------------
# exisitng enterprise subnet in vpc
#------------------------------------------------------
data "aws_subnets" "vpc-exisitng-enterprise-subnets" {
filter {
    name   = "vpc-id"
    values = [dat.aws_vpc.existing_vpc]
  }
}

#------------------------------------------------------
# exisitng public subnet in vpc
#------------------------------------------------------
data "aws_subnets" "vpc-exisitng-public-subnets" {
filter {
    name   = "vpc-id"
    values = [dat.aws_vpc.existing_vpc]
  }
}

#------------------------------------------------------
# security hardern AMI 
#------------------------------------------------------
data "aws_ami" "gloden-ami" {
  most_recent = true
  owners      = ["amazon"]
   filter {
    name   = "name"
    values = [var.ami_name]
  }
}
