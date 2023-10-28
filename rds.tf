module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.3.1"

  name           = "${local.name_prefix}-aurora-cluster"
  engine         = "aurora-postgresql"
  engine_version = "13"
  instance_class = "db.t3.medium"
  instances = {
    "${local.name_prefix}-aurora-instance-1" = {}
  }
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  db_cluster_parameter_group_family = "aurora5.6"

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  # enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  database_name               = "main"
  master_username             = "kizuku"
  manage_master_user_password = false
  master_password             = "password"

  // TODO 開発中のみ
  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name = "${local.name_prefix}-aurora-cluster"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${local.name_prefix}-rds-subnet-group"
  description = "A group of multiple subnets on which to run an instance."
  subnet_ids  = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
}