resource "aws_iam_role" "eks_load_balancer_controller_role" {
  name                = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.eks_iam_policy.arn]

  tags = {
    Name = "${local.name_prefix}-eks-load-balancer-controller-role"
  }
}

resource "aws_iam_policy" "eks_iam_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("./iam_policy.json")
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["${module.eks.oidc_provider_arn}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "bastion-ssm" {
  role       = aws_iam_role.default.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.name_prefix}-bastion-profile"
  role = aws_iam_role.default.name
}

resource "aws_iam_instance_profile" "micro_service" {
  name = "${local.name_prefix}-micro-service-profile"
  role = aws_iam_role.default.name
}

// ec2-micro-serviceにECRのroleを付与
resource "aws_iam_policy_attachment" "ec2-role-attach" {
  name       = "ec2-role-attach"
  roles      = ["${aws_iam_role.default.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role" "default" {
  name = "${local.name_prefix}-default-ec2"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

// SSMのポリシーを付与する
data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "bastion" {
  name   = "${local.name_prefix}-bastion-policy"
  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy.ssm_core.policy
}

resource "aws_iam_role" "amplify_role" {
  name = "AmplifyNextJsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "amplify.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "s3_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.amplify_role.name
}
