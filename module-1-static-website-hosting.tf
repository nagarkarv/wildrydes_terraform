#----------------------------------------------------------------
# S3 bucket for WildRydes frontend source code (src_webapp)
#----------------------------------------------------------------
resource "aws_s3_bucket" "wildrydes_s3_bucket" {
  bucket = "${var.s3-bucket-name}"
  acl = "public-read"
  force_destroy = true
  
  website {
      index_document = "index.html"
      error_document = "error.html"
  }
policy = <<EOF
{
  "Id": "bucket_policy_site",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_site_main",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.s3-bucket-name}/*",
      "Principal": "*"
    }
  ]
}
EOF
}
