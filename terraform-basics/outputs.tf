# Print attributes
output "tf_s3_bucket_1_versioning" {
    value = aws_s3_bucket.tf_s3_bucket_1.versioning[0].enabled
}

output "tf_s3_bucket_1_complete_details" {
    value = aws_s3_bucket.tf_s3_bucket_1
}

output "tf_iam_user_1_complete_details" {
    value = aws_iam_user.tf_iam_user_1
}