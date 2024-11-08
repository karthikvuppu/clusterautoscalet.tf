provider "kubernetes" {
#  host                   = aws_eks_cluster.iris_streaming_eks_kafka_cluster.endpoint
#  cluster_ca_certificate = base64decode(aws_eks_cluster.iris_streaming_eks_kafka_cluster.certificate_authority[0].data)

  host                   = module.iris_streaming_eks_kafka_cluster_module.endpoint
  cluster_ca_certificate = base64decode(module.iris_streaming_eks_kafka_cluster_module.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.iris_streaming_eks_kafka_cluster_module.id]
  }
}


##############################################################
#
# Cluster Autoscaler
#
##############################################################
module "eks-cluster-autoscaler" {
  source  = "lablabs/eks-cluster-autoscaler/aws"
  version = "2.1.0"
  # insert the 3 required variables here
  #cluster_identity_oidc_issuer = aws_eks_cluster.iris_streaming_eks_kafka_cluster.identity[0].oidc.issuer
  cluster_identity_oidc_issuer = "https://oidc.eks.eu-north-1.amazonaws.com/id/7167CE64C553C9C6193B24B9E027B0AF"
  cluster_identity_oidc_issuer_arn = "arn:aws:iam::572663323550:oidc-provider/oidc.eks.eu-north-1.amazonaws.com/id/7167CE64C553C9C6193B24B9E027B0AF"
  cluster_name = var.eks_cluster_name
}  
