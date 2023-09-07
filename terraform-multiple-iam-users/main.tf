# Creating Indexed Users
variable "iam_user_prefix" {
    default = "tf-iam-user"
}

# Creating Users From List Of Users
variable "iam_user_names" {
    default = ["john.doe", "jane.doe"]
}

# Configure Provider
provider "aws" {
    shared_credentials_files = ["~/.aws/credentials"]
    profile = "default"
    region = "us-east-1"
}

# Create Multiple IAM Users
resource "aws_iam_user" "tf_iam_users_1" {
    count = 3
    name = "${var.iam_user_prefix}-${count.index}"
}

resource "aws_iam_user" "tf_iam_users_2" {
    count = length(var.iam_user_names)
    name = var.iam_user_names[count.index]
}