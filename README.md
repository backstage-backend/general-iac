# Backend APIs infrastructure

This stack creates only the shared infrastructure needed by backend APIs:

- EKS `eks-backend-apis` on Kubernetes `1.37`
- A managed node group using smaller `t3.small` instances
- The `api-gtw-lambda-apis` regional REST API

The EKS cluster uses the private subnets from the existing `backstage-vpc`.
The stack does not create a VPC, RDS database, ECR repository, Lambda
functions, Kubernetes workloads, routes, deployments, stages, or integrations.
API repositories can add their own Lambda integrations against the API Gateway
ID output.

Terraform state uses the same S3 backend convention as the existing stack.
Create the state bucket first, then initialize with a distinct state key:

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init \
  -backend-config="bucket=YOUR_TF_STATE_BUCKET" \
  -backend-config="key=backend-apis/terraform.tfstate" \
  -backend-config="region=us-east-2" \
  -backend-config="encrypt=true"
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
```

The `existing_vpc_name` value must match the `Name` tag of the VPC created by
the existing Backstage infrastructure. The API Gateway is intentionally
created without routes, deployments, stages, or Lambda integrations; those are
supplied by the service repositories.

## GitHub Actions

The `Terraform Validate` workflow runs formatting, initialization without a
backend, and validation for pull requests.

The `Deploy Backend APIs Infrastructure` workflow uses the
`aws-infrastructure` environment and the `backend-apis/terraform.tfstate` key.
Pushes to `main` apply automatically. Manual runs with `apply=false` only
create a plan; use `apply=true` to apply it.

Configure these values in the `aws-infrastructure` environment:

- Variable `TF_STATE_BUCKET`: existing private S3 bucket for Terraform state
- Secret `AWS_ACCESS_KEY_ID`
- Secret `AWS_SECRET_ACCESS_KEY`
- Secret `AWS_SESSION_TOKEN` (optional, for temporary credentials)
