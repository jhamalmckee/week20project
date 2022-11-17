#---cluster/outputs.tf---


output "endpoint" {
  value = aws_eks_cluster.week20-week20.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.week20-week20.certificate_authority[0].data
}
output "cluster_id" {
  value = aws_eks_cluster.week20-week20.id
}
output "cluster_endpoint" {
  value = aws_eks_cluster.week20-week20.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.week20-week20.name
}
