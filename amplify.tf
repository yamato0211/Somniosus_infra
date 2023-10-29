# resource "aws_amplify_app" "frontend" {
#   name                 = "${local.name_prefix}-frontend"
#   iam_service_role_arn = aws_iam_role.amplify_role.arn
#   repository           = var.github_url
#   access_token         = var.github_token

#   # The default build_spec added by the Amplify Console for React.
#   build_spec = <<-EOT
#     version: 1
#     frontend:
#       phases:
#         preBuild:
#           commands:
#             - curl -fsSL https://bun.sh/install | bash
#             - export PATH="$HOME/.bun/bin:$PATH"  # Add Bun to the PATH
#             - bun --version                       # Check if Bun is accessible
#             - bun install
#         build:
#           commands:
#             - bun run build
#       artifacts:
#         baseDirectory: .next
#         files:
#           - '**/*'
#       cache:
#         paths:
#           - node_modules/**/*
#   EOT

#   # The default rewrites and redirects added by the Amplify Console.
#   custom_rule {
#     source = "/<*>"
#     status = "404-200"
#     target = "/index.html"  
#   }

#   enable_branch_auto_build    = true
#   enable_branch_auto_deletion = true
#   platform                    = "WEB"

#   environment_variables = {
#     NEXT_PUBLIC_BACKEND_URL = var.backend_url
#     ACCESS_KEY_ID           = var.access_key
#     SECRET_ACCESS_KEY       = var.secret_key
#     REGION                  = local.region
#     S3_BUCKET_NAME          = aws_s3_bucket.nextjs_bucket.bucket
#   }

#   tags = {
#     Name = "${local.name_prefix}-frontend"
#   }
# }

# resource "aws_amplify_branch" "main" {
#   app_id      = aws_amplify_app.frontend.id
#   branch_name = "main"

#   enable_auto_build = true
#   framework         = "Next.js - SSR"
#   stage             = "PRODUCTION"
# }