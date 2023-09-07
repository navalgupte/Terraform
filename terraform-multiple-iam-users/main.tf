# Creating Variables
variable "iam_user_prefix" {
    default = "tf-iam-user"
}
# Configure Provider
provider "aws" {
    shared_credentials_files = ["~/.aws/credentials"]
    profile = "default"
    region = "us-east-1"
}

# Create Multiple IAM Users
resource "aws_iam_user" "tf_iam_users" {
    count = 3
    name = "${var.iam_user_prefix}-${count.index}"
}