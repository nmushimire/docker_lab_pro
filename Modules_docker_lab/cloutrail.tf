# Enable cloud Trail to manage logs of infra
# Create an S3 bucket to store CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = "your-cloudtrail-bucket-name"
  force_destroy = true
}

# Create an AWS KMS key for encrypting CloudTrail logs
resource "aws_kms_key" "cloudtrail_key" {
  description             = "CloudTrail log encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Create an IAM role for CloudTrail to assume
resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach the required policy to the CloudTrail role
resource "aws_iam_role_policy_attachment" "cloudtrail_role_policy" {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Create the CloudTrail trail
resource "aws_cloudtrail" "cloudtrail" {
  name                          = "your-cloudtrail-name"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.cloudtrail_key.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
}

# Create a CloudWatch log group for CloudTrail logs
resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name = "cloudtrail-log-group"
}

