# --------------------------------------------------
# Remote State for our application 
# --------------------------------------------------
terraform {
  backend "s3" {
    bucket         = "<your_state_bucket_here>"
    key            = "dev-sandbox/wildrydes_terraform/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform"
  }
}