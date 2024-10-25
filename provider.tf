#https://terraformguru.com/terraform-real-world-on-aws-ec2/15-Autoscaling-with-Launch-Templates/
#---------------------------------------------------
# Configure the AWS Provider
#---------------------------------------------------
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.73.0"
    }
  }
  backend "s3" {
    bucket = "tf-state-store"
    key    = "/gitlab-runner/runner.tfstate"
    region = "us-east-1" # Replace with your desired region
    dynamodb_table = "tfstate-lock-table"
    encrypt = true
  }
}
#---------------------------------------------------
# Configure the AWS Provider
#---------------------------------------------------
provider "aws" {
  region = "us-west-1" 
  profile = "cicd-deployment"
  assume_role {
    role_arn = ""
    session_name = ""
  }
}
