resource "vercel_project" "example" {
  name      = "onden-front"
  framework = "nextjs"

  git_repository = {
    type = "github"
    # ユーザー名/リポジトリ名は置き換えてください
    repo = var.github_url
  }
}

resource "vercel_project_environment_variable" "backend_url" {
  project_id = vercel_project.example.id
  key        = "NEXT_PUBLIC_BACKEND_URL"
  value      = var.backend_url
  target     = ["production"]
}

resource "vercel_project_environment_variable" "access_key" {
  project_id = vercel_project.example.id
  key        = "ACCESS_KEY_ID"
  value      = var.access_key
  target     = ["production"]
}

resource "vercel_project_environment_variable" "secret_key" {
  project_id = vercel_project.example.id
  key        = "SECRET_ACCESS_KEY"
  value      = var.secret_key
  target     = ["production"]
}

resource "vercel_project_environment_variable" "region" {
  project_id = vercel_project.example.id
  key        = "REGION"
  value      = local.region
  target     = ["production"]
}

resource "vercel_project_environment_variable" "bucket_name" {
  project_id = vercel_project.example.id
  key        = "S3_BUCKET_NAME"
  value      = aws_s3_bucket.nextjs_bucket.bucket
  target     = ["production"]
}


resource "vercel_deployment" "example" {
  project_id  = vercel_project.example.id
  ref        = "main"
  production  = true
}