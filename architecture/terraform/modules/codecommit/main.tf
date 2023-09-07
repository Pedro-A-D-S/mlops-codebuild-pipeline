provider "aws" {
    region = "us-east-1"
}

resource "aws_codecommit_repository" "my_repo" {
    repository_name = var.repository_name
    description = var.repo_description
}
