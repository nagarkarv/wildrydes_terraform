# --------------------------------------------------
# DynamoDB Rides Table 
# --------------------------------------------------
resource "aws_dynamodb_table" "Rides_table" {
  name = "${var.dynamodb_table_name}"
  hash_key = "RideId"
  attribute {
      name = "RideId"
      type = "S"
  }
  read_capacity  = 20
  write_capacity = 20  
}

# ----------------------------------------------------------
# IAM Roles: Allow Lambda and API Gateway to assume the role 
# ----------------------------------------------------------
resource "aws_iam_role" "WildRydesLambda" {
    name = "WildRydesLambda"
    description = "IAM Role to WildRydes Lambda"
  // This is a trust relation ship to define who can assume this role
  // The following trusted entities(services) can assume this role
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com",
                "Service": "apigateway.amazonaws.com",
                "Service": "dynamodb.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
  EOF
}

# --------------------------------------------------
# CloudWatch access for Lambda 
# --------------------------------------------------
resource "aws_iam_policy" "LambdaCloudWatchAccess" {
  name = "LambdaCloudWatchAccess"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# --------------------------------------------------
# Attach CloudWatch Access policy to IAM Role
# --------------------------------------------------
resource "aws_iam_role_policy_attachment" "LambdaCloudWatchAccess_attachment" {
  role       = "${aws_iam_role.WildRydesLambda.name}"
  policy_arn = "${aws_iam_policy.LambdaCloudWatchAccess.arn}"
}

# --------------------------------------------------
# DynamoDB Write access policy for Lambda 
# --------------------------------------------------
resource "aws_iam_policy" "LambdaDynamoDBWriteAccess" {
  name = "LambdaDynamoDBWriteAccess"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:PutItem"
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.Rides_table.arn}"
    }
  ]
}
EOF
}

# --------------------------------------------------
# Attach DynamoDB Write access policy to IAM role
# --------------------------------------------------
resource "aws_iam_role_policy_attachment" "LambdaDynamoDBWriteAccess_attachmemnt" {
  role       = "${aws_iam_role.WildRydesLambda.name}"
  policy_arn = "${aws_iam_policy.LambdaDynamoDBWriteAccess.arn}"
}

# --------------------------------------------------
# The Lambda Function 
# --------------------------------------------------
resource "aws_lambda_function" "WildRydes_Lambda_Function" {    
    filename = "${var.lambda_function_filename}"
    function_name = "${var.lambda_function_name}"
    handler = "${var.lambda_handler}"
    runtime = "${var.lambda_runtime}"
    source_code_hash = "${base64sha256(file("${var.lambda_function_filename}"))}"

    // execution role for lambda - Allow Lambda to execute
    role = "${aws_iam_role.WildRydesLambda.arn}"
}
