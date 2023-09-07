provider "aws" {
  region = "us-east-1"
}

resource "aws_codepipeline" "pipeline_v1_mlops" {
  name     = "pipeline-v1-mlops"
  role_arn = "arn:aws:iam::YOUR_ACCOUNT_ID:role/AWSCodePipelineServiceRole-ap-south-1-pipeline-v1-mlops"

  artifact_store {
    location = ""
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name            = "SourceAction"
      category        = "Source"
      owner           = "AWS"
      provider        = "CodeCommit"
      version         = "1"
      output_artifacts = ["SourceOutput"]

      configuration {
        RepositoryName = "codepipeline"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "BuildAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      version         = "1"

      configuration {
        ProjectName = "codepipeline"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["BuildOutput"]
      version         = "1"

      configuration {
        ApplicationName  = "codepipeline"
        DeploymentGroupName = "dev-deploy"
      }
    }
  }
}