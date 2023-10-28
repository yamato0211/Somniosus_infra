resource "aws_ecr_repository" "somniosus_repository" {
  name                 = "${local.name_prefix}-repository"
  image_tag_mutability = "MUTABLE"

  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${local.name_prefix}-repository"
  }
}