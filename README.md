# MLOps Pipeline

This repository contains an MLOps pipeline implemented using Terraform for infrastructure provisioning and AWS services. The pipeline automates the deployment of machine learning models and associated resources.

## MLOps Architecture

You can visualize the architecture by running the Python script provided in the `src` folder. Execute `python src/diagram.py` to generate a diagram and save it in the `images` folder as `pipeline.png`.

![Pipeline Architecture](images/pipeline.png)

## Pipeline Overview

The MLOps pipeline consists of the following components:

- **CodeBuild:** This module is responsible for building your machine learning models.
- **CodeCommit:** This module stores your source code and version history.
- **CodeDeploy:** It automates the deployment of your models to EC2 instances.
- **CodePipeline:** This module orchestrates the entire pipeline.
- **Deployment Group:** Manages the deployment of models to EC2 instances.
- **EC2 Instances:** Compute resources for running machine learning models.
- **S3:** Stores static files required for the pipeline.

## Project Structure

```
├── architecture
│   └── terraform
│       ├── main.tf
│       └── modules
│           ├── codebuild
│           │   ├── main.tf
│           │   └── outputs.tf
│           ├── codecommit
│           │   ├── main.tf
│           │   ├── outputs.tf
│           │   └── variables.tf
│           ├── codedeploy
│           │   ├── main.tf
│           │   └── outputs.tf
│           ├── codepipeline
│           │   ├── main.tf
│           │   └── variables.tf
│           ├── deployment_group
│           │   ├── main.tf
│           │   └── outputs.tf
│           ├── ec2
│           │   ├── main.tf
│           │   ├── outputs.tf
│           │   └── user_data.sh
│           └── s3
│               ├── main.tf
│               └── outputs.tf
├── images
│   └── pipeline.png
└── src
    ├── diagram.py
    └── requirements.txt
```

## Usage

1. Clone this repository.
2. Modify the Terraform configurations in the `architecture/terraform` directory to match your requirements.
3. Run `terraform init` to initialize the Terraform project.
4. Run `terraform apply` to create the AWS resources.
5. Monitor the pipeline and access your deployed models.

## Requirements

Ensure you have the necessary dependencies installed by running:

```bash
pip install -r src/requirements.txt
``````

## License

This project is licensed under the MIT License. file for details.

## Contact

For any questions or inquiries, please contact:

- [PedroAlves](pedroalves0409@gmail.com)
- [LinkedIn](https://www.linkedin.com/in/pedro-a-d-s/)
