module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  cluster_version                = "1.24"
  cluster_name                   = "${local.name_prefix}-eks"
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  enable_irsa                    = true
  eks_managed_node_groups = {
    main = {
      desired_size   = 1
      instance_types = ["t3.medium"]
    }
  }
  tags = {
    Name = "${local.name_prefix}-eks"
  }
}

output "aws_auth_config_map" {
  value = module.eks.aws_auth_configmap_yaml
}

# resource "aws_security_group_rule" "allow_ingress_port" {
#   security_group_id        = module.eks.node_security_group_id
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.allow_ingress_port.id
# }

# output "eks_cluster_sg_id" {
#   value       = module.eks.cluster_security_group_id
#   description = "description"
# }

# output "eks_node_sg_id" {
#   value       = module.eks.node_security_group_id
#   description = "description"
# }
