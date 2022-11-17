#---root/providers.tf---

terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(module.cluster.kubeconfig-certificate-authority-data)
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token

}

data "aws_eks_cluster" "cluster" {
  name = module.cluster.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_id
}
