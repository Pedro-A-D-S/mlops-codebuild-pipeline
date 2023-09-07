provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
    bucket = "aws-manifold-devops-1"
    acl = private
    versioning {
        enabled = true
    }
}