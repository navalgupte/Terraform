variable "users" {
  default = {
    john : { country : "US", department : "Engineering" }
    jane : { country : "Canada", department : "Research And Development" }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "iam_users" {
  for_each = var.users
  name     = each.key
  tags = {
    country : each.value.country
    department : each.value.department
  }
}