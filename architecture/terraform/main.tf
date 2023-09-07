provider "aws" {
    region = "us-east-1"
}

module "s3" {
    source = "./modules/s3"
}

module "ec2" {
    source = "./modules/ec2"
}

module "codecommit" {
    source = "./modules/codecommit"
}

module "codebuild" {
  source = "./modules/codebuild"
}

module "codedeploy" {
    source "./modules/codedeploy"
}

module "deployment_group" {
  source = "./modules/deployment_group"
}

module "codepipeline" {
    source = "./modules/codepipeline"
}

