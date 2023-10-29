variable "access_key" {
  type        = string
  default     = ""
  description = "aws iam access key id"
}

variable "secret_key" {
  type        = string
  default     = ""
  description = "aws iam secret key"
}

variable "backend_url" {
  type        = string
  default     = ""
  description = "backend url"
}

variable "github_url" {
  type        = string
  default     = ""
  description = "frontend github repository url"
}

variable "github_token" {
  type        = string
  default     = ""
  description = "github personal access token"
}

variable "my_domain" {
  type        = string
  default     = ""
  description = "my domain"
}

variable "alb_endpoint" {
  type        = string
  default     = ""
  description = "eks cluster alb address"
}

variable "vercel_api_token" {
  type        = string
  default     = ""
  description = "vercel api token"
}


