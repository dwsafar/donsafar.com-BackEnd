
resource "aws_s3_bucket" "root" {
  // S3 buck for root domain
  bucket = var.root_domain_name
  acl           = "public-read"
  force_destroy = true
  policy = <<POLICY

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipalReadOnly",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.root_domain_name}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::${var.accountId}:distribution/${data.aws_cloudfront_distribution.test.id}"
                }
            }
        }
    ]
}
POLICY
  website {
    index_document = "index.html"

    error_document = "404.html"
  }
    lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket" "www" {
  bucket = var.www_domain_name
  acl    = "public-read"
  website {
    redirect_all_requests_to = var.root_domain_name
  }
    lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${var.root_domain_name}"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}