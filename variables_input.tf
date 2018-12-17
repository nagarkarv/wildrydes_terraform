# -----------------------------------------------------------------------------
# Module 1 - Variables: S3 Website
# -----------------------------------------------------------------------------
variable "s3-bucket-name" {
    default = "<your_s3_code_bucket_here>"
}

# -----------------------------------------------------------------------------
# Module 2 - Variables: Cognito
# -----------------------------------------------------------------------------
variable "cognito_user_pool" {
    default = "wildrydes_userpool"
}

variable "cognito_user_pool_client" {
    default = "WildRydesWebApp"
}

# -----------------------------------------------------------------------------
# Module 3 - Variables: Backend
# -----------------------------------------------------------------------------
variable "dynamodb_table_name" {
    default = "Rides"
}

variable "lambda_function_name" {
    default = "RequestUnicorn"
}

variable "lambda_handler" {
    default = "requestUnicorn.handler"
}

variable "lambda_runtime" {
    default = "nodejs6.10"
}

variable "lambda_function_filename" {
    default = "requestUnicorn.zip"
}

# -----------------------------------------------------------------------------
# Module 4 - Variables: CORS
# -----------------------------------------------------------------------------
variable "allowed_headers" {
  description = "Allowed headers"
  type        = "list"

  default = [
    "Content-Type",
    "X-Amz-Date",
    "Authorization",
    "X-Api-Key",
    "X-Amz-Security-Token",
  ]
}

variable "allowed_methods" {
  description = "Allowed methods"
  type        = "list"

  default = [
    "OPTIONS",
    "HEAD",
    "GET",
    "POST",
    "PUT",
    "PATCH",
    "DELETE",
  ]
}

variable "allowed_origin" {
  description = "Allowed origin"
  type        = "string"
  default     = "*"
}

variable "allowed_max_age" {
  description = "Allowed response caching time"
  type        = "string"
  default     = "7200"
}
