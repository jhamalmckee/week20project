#---cluster/main.tf---

resource "random_string" "random" {
  length  = 5
  special = false
}

resource "aws_eks_cluster" "choco20-choc20" {
  name     = "choco20-choc20"-${random_string.random.result}"
  role_arn = aws_iam_role.week20-week20.arn

  vpc_config {
    subnet_ids              = var.public_subnets
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    security_group_ids      = [aws_security_group.choco20-choc20-node-group.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.choco20-choc20-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.choco20-choc20-AmazonEKSVPCResourceController,
  ]
}



resource "aws_eks_node_group" "choco20-choc20" {
  cluster_name   = aws_eks_cluster.choco20-choc20.name
  node_role_arn  = aws_iam_role.choco20-choc20-cluster.arn
  subnet_ids     = var.public_subnets[*]
  instance_types = var.instance_types

  remote_access {
    source_security_group_ids = [aws_security_group.choco20-choc20-node-group.id]
    ec2_ssh_key               = var.key_pair
  }

  scaling_config {
    min_size     = 1
    max_size     = 3
    desired_size = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.choco20-choc20-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.choco20-choc20-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.choco20-choc20-AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_security_group" "choco20-choc20-node-group" {
  name_prefix = "choco20-choc20-node-group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_iam_role" "choco20-choc20" {
  name = "choco20-choc20-eks-cluster"

  assume_role_policy = jsonencode({

    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        "Service" : "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role" "choco20-choc20-cluster" {
  name = "choco20-choc20-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "choco20-choc20-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.choco20-choc20.name
}

resource "aws_iam_role_policy_attachment" "choco20-choc20-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.choco20-choc20-cluster.name
}

resource "aws_iam_role_policy_attachment" "choco20-choc20-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.choco20-choc20-cluster.name
}

resource "aws_iam_role_policy_attachment" "choco20-choc20-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.choco20-choc20-cluster.name
}

resource "aws_iam_role_policy_attachment" "choco20-choc20-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.choco20-choc20.name
}
