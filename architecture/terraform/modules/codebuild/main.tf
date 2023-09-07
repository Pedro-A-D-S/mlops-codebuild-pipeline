provider "aws" {
    region = "us-east-1"
}

resource "aws_codebuild_project" "codepipeline" {
    name = "codepipeline"
    description = "CodeBuild project for CodePipeline"

    built_timeout = 60
    build_timeout_warnings = 5
    service_role = aws_iam_role.codebuild_role.arn

    source {
        type = "CODEPIPELINE"
        buildspec = file("buildspec.yml")
    }

    source {
        type = "CODECOMMIT"
        location = "codepipeline"
        buildspec = file("buildspec.yml")
    }

    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image = "aws/codebuild/amazonlinux2-aarch64-standard:2.0"
        type = "LINUX_CONTAINER"
    }

    artifacts {
        type = "S3"
        location = "aws-manifold-devops-1"
        packaging = "ZIP"
    }
}

