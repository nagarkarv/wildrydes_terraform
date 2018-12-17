# -----------------------------------------------------
# API Gateway for WindRydes
# --------------------------------------------------
resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "WildRydes"
  description = "API Gateway WildRydes"
}
# -------------------------------------------------------------------
# Authorizer for the API Gateway - This will be the Cognito user pool 
# -------------------------------------------------------------------
resource "aws_api_gateway_authorizer" "WildRydes" {
    name = "WildRydes"
    type = "COGNITO_USER_POOLS" 
    rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
    authorizer_credentials = "${aws_iam_role.WildRydesLambda.arn}"
    provider_arns = ["${aws_cognito_user_pool.user_pool.arn}"]
}

# --------------------------------------------------
# API Resource for "ride"
# --------------------------------------------------
resource "aws_api_gateway_resource" "ride" {
    rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
    parent_id = "${aws_api_gateway_rest_api.api_gateway.root_resource_id}"
    path_part = "ride"
}

# -------------------------------------------------------------
# Enable CORS
# This requires an OPTIONS method to be created
# -------------------------------------------------------------
resource "aws_api_gateway_method" "CORS" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.ride.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "CORS" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.ride.id}"
  http_method = "${aws_api_gateway_method.CORS.http_method}"

  type = "MOCK"

  request_templates {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

resource "aws_api_gateway_integration_response" "CORS" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.ride.id}"
  http_method = "${aws_api_gateway_method.CORS.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'${join(",", var.allowed_headers)}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${join(",", var.allowed_methods)}'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.allowed_origin}'"
    "method.response.header.Access-Control-Max-Age"       = "'${var.allowed_max_age}'"
  }

  depends_on = [
    "aws_api_gateway_integration.CORS",
  ]
}

resource "aws_api_gateway_method_response" "CORS" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.ride.id}"
  http_method = "${aws_api_gateway_method.CORS.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Max-Age"       = true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    "aws_api_gateway_method.CORS",
  ]
}

# ----------------------------------------------------
# "ride" method for the resource "ride" 
# -----------------------------------------------------
resource "aws_api_gateway_method" "ride" {
    rest_api_id   = "${aws_api_gateway_rest_api.api_gateway.id}"
    resource_id   = "${aws_api_gateway_resource.ride.id}"
    http_method   = "POST"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = "${aws_api_gateway_authorizer.WildRydes.id}"
}

# --------------------------------------------------
# Integration for the ride method
# --------------------------------------------------
resource "aws_api_gateway_integration" "ride_integration" {
    rest_api_id   = "${aws_api_gateway_rest_api.api_gateway.id}"
    resource_id   = "${aws_api_gateway_resource.ride.id}"
    http_method   = "${aws_api_gateway_method.ride.http_method}"
    type          = "AWS_PROXY"
    integration_http_method = "POST"
    uri = "arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/${aws_lambda_function.WildRydes_Lambda_Function.arn}/invocations"  
}

# ----------------------------------------------------
# Lambda gving permission to API gateway to be invoked 
# ----------------------------------------------------
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyWildRydesAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.WildRydes_Lambda_Function.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/POST/ride"
}

# --------------------------------------
# Deploy to Test stage
# --------------------------------------
resource "aws_api_gateway_deployment" "wildrydes_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
  stage_name = "Test"
  depends_on = ["aws_api_gateway_integration.ride_integration",
               "aws_lambda_permission.lambda_permission"]  
}

