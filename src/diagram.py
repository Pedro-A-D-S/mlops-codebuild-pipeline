from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.storage import S3
from diagrams.aws.devtools import Codecommit, Codebuild, Codepipeline

# Ajuste o tamanho da fonte e a cor de fundo
graph_attr = {
    "fontsize": "20",
    "bgcolor": "white"
}

# Ajuste a cor das caixas de cluster
cluster_attr = {
    "bgcolor": "lightgray"
}

with Diagram("MLOps Pipeline", show=True, direction="TB", graph_attr=graph_attr):
    # Cluster Terraform
    with Cluster("Pipeline", graph_attr=cluster_attr):
        with Cluster("AWS", graph_attr=cluster_attr):
            codebuild = Codebuild("CodeBuild")
            codecommit = Codecommit("CodeCommit")
            codedeploy = Codepipeline("CodeDeploy")
            codepipeline = Codepipeline("CodePipeline")
            deployment_group = Codepipeline("Deployment Group")

            # Cluster para criar espaço
            with Cluster("EC2 Instances", graph_attr=cluster_attr):
                ec2 = EC2("EC2-1")
                ec2 = EC2("EC2-2")
                ec2 = EC2("EC2-3")
                ec2 = EC2("EC2-4")

            s3 = S3("S3")

            # Defina as direções das conexões (edges) e ajuste o estilo das arestas
            style = {"fontsize": "14", "color": "gray"}
            codebuild - Edge(label="Build", dir="TB", style=style) - codepipeline
            codecommit - Edge(label="Source Code", dir="TB", style=style) - codepipeline
            codepipeline - Edge(label="Deploy", dir="TB", style=style) - codedeploy
            deployment_group - Edge(label="Deployment", dir="TB", style=style) - ec2
            s3 - Edge(label="Static Files", dir="TB", style=style) - ec2
