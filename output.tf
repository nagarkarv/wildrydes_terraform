#------------------------------------------------------------------------------------
# Outputs: Values from the 3 outputs should be copied to relevant varaibles in config.js
# dev-sandbox\wildrydes_serverless\src_webapp\js\config.js
#-------------------------------------------------------------------------------------

# userPoolId
output "user_pool_id" {
  value = "${aws_cognito_user_pool.user_pool.id}"
}

# userPoolClientId
output "user_pool_client_id" {
  value = "${aws_cognito_user_pool_client.app_client.id}"
}

# invokeUrl
output "lambda_base_url" {
  value = "${aws_api_gateway_deployment.wildrydes_api_deployment.invoke_url}"
}
