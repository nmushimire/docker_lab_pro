terraform {
  backend "s3" {
    bucket         = "XXXXXXXXXXXXXXXXXXXXXXXXX"
    key            = "path/to/my/state/file"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-locks"
    encrypt = false
  }
}
