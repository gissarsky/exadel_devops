provider "kubernetes" {
    #version = "2.4.1"
    #load_config_file = "false"
    host = data.aws_eks_cluster.exadel-cluster.endpoint
    token = data.aws_eks_cluster_auth.exadel-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.exadel-cluster.certificate_authority.0.data)
}

# Query data of host
data "aws_eks_cluster" "exadel-cluster" {
    name = module.eks.cluster_id
}

# Query data of authentication

data "aws_eks_cluster_auth" "exadel-cluster" {
    name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.18.0"
  
  # Define a cluster name and version
  cluster_name = "exadel-eks-cluster"
  cluster_version = "1.21"

  # Define list of subnet for worker nodes

  subnets = module.kuber-vpc.private_subnets
  vpc_id = module.kuber-vpc.vpc_id

  tags = {
      environment = "development"
      application = "shuup"
  }

  # Define worker groups

  worker_groups = [
      {
          instance_type = "t2.micro"
          name = "worker-group-1"
          asg_desired_capacity = 3
      }
  ]
}
