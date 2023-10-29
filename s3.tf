resource "aws_s3_bucket" "nextjs_bucket" {
  bucket = "${local.name_prefix}-nextjs-app-bucket"
}