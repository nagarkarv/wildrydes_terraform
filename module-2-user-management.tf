#---------------------------------------------------------------------
# Cognito setup for user management
#---------------------------------------------------------------------
resource "aws_cognito_user_pool" "user_pool" {
    name = "${var.cognito_user_pool}"
    
    // Cognito will send the verification code to the registered email
    auto_verified_attributes = ["email"] 
}

# --------------------------------------------------
# Create a App Client in the pool
# --------------------------------------------------
resource "aws_cognito_user_pool_client" "app_client" {
    name = "${var.cognito_user_pool_client}"
    user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
    generate_secret = false
}
