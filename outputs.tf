output "cluster_name" {
  description = "Name of the dedicated EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint for the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "api_gateway_id" {
  description = "ID of the API Gateway reserved for Lambda APIs."
  value       = aws_api_gateway_rest_api.lambda_apis.id
}
