data "aws_vpc" "backstage" {
  filter {
    name   = "tag:Name"
    values = [var.existing_vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.backstage.id]
  }

  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.37"

  cluster_endpoint_public_access = true

  vpc_id     = data.aws_vpc.backstage.id
  subnet_ids = data.aws_subnets.private.ids

  enable_irsa                              = false
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      instance_types = [var.node_instance_type]
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
    }
  }
}

resource "aws_api_gateway_rest_api" "lambda_apis" {
  name        = "api-gtw-lambda-apis"
  description = "API Gateway for Lambda-backed APIs."

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
