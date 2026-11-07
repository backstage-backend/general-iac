variable "aws_region" {
  description = "AWS region where the EKS cluster and API Gateway are deployed."
  type        = string
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "Name of the dedicated EKS cluster."
  type        = string
  default     = "eks-backend-apis"
}

variable "existing_vpc_name" {
  description = "Name tag of the VPC created by the existing Backstage stack."
  type        = string
  default     = "backstage-vpc"
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS managed node group."
  type        = string
  default     = "t3.medium"
}

variable "node_min_size" {
  description = "Minimum number of EKS worker nodes."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of EKS worker nodes."
  type        = number
  default     = 4
}

variable "node_desired_size" {
  description = "Desired number of EKS worker nodes."
  type        = number
  default     = 2
}
