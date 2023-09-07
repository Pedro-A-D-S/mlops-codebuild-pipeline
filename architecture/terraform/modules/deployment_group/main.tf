provider "aws" {
    region = "us-east-1"
}

resource "aws_code_deploy_deployment_group" "dev_deploy" {
    app_name = codepipeline
    deployment_group-name = "dev_deploy"
    source_role_arn = var.DEPLOYMENT_ROLE_ARN

    auto_rollback_configuration {
        enabled = true
        events = ["DEPLOYMENT_FAILURE"]
    }

    deployment_style {
        deployment_option = "WITH_TRAFFIC_CONTROL"
        deployment_type = "IN_PLACE"
    }

    ec2_tag_set {
        ec2_tag_filter {
            key = "Name"
            value = "dev-v1"
            type = "KEY_AND_VALUE"
        }
        include_boot_tags = true
    }

    load_balancer_info (
        elb_info {
            name = "Load"
        }
    )

    trigger_configurations {
        trigger_name = ""
        trigger_target_arn = ""
        trigger_events = []
    }
}