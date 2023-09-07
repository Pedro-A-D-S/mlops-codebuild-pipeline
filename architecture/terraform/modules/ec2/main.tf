provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
    count = 4
    ami = "mi-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    key_name = "codedeploy-ml-pipeline"
    user_data = file("user_data.sh")

    root_block_service {
        volume_size = 10
    }

    network_security_group_ids = [aws_security_group.ec2_security_group.id]

    iam_instance_profile = "codedeploy-mlops-ec2"
}

resource "aws_security_group "ec2_security_group" {
    name = "ec2_security_group"
    description = "Security group for EC2 instances"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}