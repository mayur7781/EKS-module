data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = "my-cluster"
  vpc_id          = "vpc-02f98d9d3d965d33d"
  subnets         = ["subnet-0b5f26090c6d6c913", "subnet-0c2fa95046a9fcb1a"]

  worker_groups = [
    {
      instance_type = "t2.micro"
      asg_max_size  = 1
    }
  ]
}
