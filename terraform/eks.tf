resource "aws_eks_cluster" "main" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }
}


resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "null_resource" "bootstrap_script" {
  depends_on = [aws_eks_node_group.workers]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for EKS cluster to be ready..."
      aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster
      
      echo "Installing Helm..."
      curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

      echo "Adding Helm repo..."
      helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
      helm repo update

      echo "Deploying NGINX Ingress Controller..."
      helm install nginx-ingress ingress-nginx/ingress-nginx \
        --set controller.service.type=LoadBalancer \
        --set controller.service.externalTrafficPolicy=Local
      git clone https://github.com/yishvendrabaghel/particle41.git
      cd particle41/helm/
      helm install simple-time-service ./simpleTimeService/
    EOT
  }
}


