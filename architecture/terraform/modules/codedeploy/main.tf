provider "aws" {
    region = "us-east-1"
}

resource "aws_codedeploy_app" "codepipeline" {
    name = "codepipeline"
    compute_platform = "EC2/OnPremises"
}