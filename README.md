# wildrydes_terraform
WildRydes (Serverless Web Application) with Terraform in AWS

### Introduction

**WildRydes** application is from one of the AWS getting started projects. 

Manual steps to build and deploy is avaliable [here](https://aws.amazon.com/getting-started/projects/build-serverless-web-app-lambda-apigateway-s3-dynamodb-cognito/)  

The application uses the following AWS services

AWS Lambda

Amazon API Gateway

Amazon S3

Amazon Dynamodb

Amazon Cognito

Application gets deployed in `eu-west-2` region by default

#### Terraform is used to build the Web App on AWS

### Usage
#### Remote State
- S3 is used as a remote storage for your infrastructure state. So you will need to have an existing bucket which can be used to store the state remotely.

- Update bucket name in `remote_state.tf`

```terraform
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
```

- S3 bucket to upload the website code. Bucket names are globally unique so you would need to update your bucket in `variables_input.tf`

```
variable "s3-bucket-name" {
    default = "<your_s3_code_bucket_here>"
}
```

#### Terraform
Change the current directory to `wildrydes_terraform` and execute the following  
```
$ terraform init
$ terraform plan
$ terraform apply
```

After apply, you will get 3 outputs.
```
Apply complete! Resources: 21 added, 0 changed, 0 destroyed.

Outputs:

lambda_base_url = https://1lcyeokpe6.execute-api.eu-west-2.amazonaws.com/Test
user_pool_client_id = 4mkt3h62iq79628019d7r41787
user_pool_id = eu-west-2_A4HfohzmL
```
 Update the values in `src_webapp\js\config.js`

```javascript
window._config = {
    cognito: {
        userPoolId: '<user_pool_id_here>', 
        userPoolClientId: '<user_pool_client_id_here>', 
        region: 'eu-west-2'
    },
    api: {
        invokeUrl: '<lambda_base_url_here>'
    }
};
```
upload the code from `src_webapp` to s3 bucket

`WildRydes` Web Application should be avaliable at 
```
http://<your_s3_code_bucket_here>.s3-website.eu-west-2.amazonaws.com/
```

### Destroy your resources as it may cost you money
```
terraform destroy
```
