terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configure Provider
provider "aws" {
    shared_credentials_files = ["~/.aws/credentials"]
    profile = "default"
    region = "us-east-1"
}

# Create Resources
resource "aws_s3_bucket" "tf_s3_bucket_1" {
    bucket = "tf-s3-bucket-1"
}

# Create IAM User
resource "aws_iam_user" "tf_iam_user_1" {
    name = "tf-iam-user-1"
}

# Enable Versioning - Check Terraform Dcoumentation
#resource "aws_s3_bucket_versioning" "s3_enable_versioning" {
#    bucket = aws_s3_bucket.tf_s3_bucket_1.id
#    versioning_configuration {
#        status = "Enabled"
#    }
#}
