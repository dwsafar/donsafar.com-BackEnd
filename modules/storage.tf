// S3 Storage and Cloudfront creation for website
## refer to variables.tf 

resource "aws_s3_bucket" "root" {
  // S3 buck for root domain
  bucket        = var.root_domain_name
  acl           = "private"
  force_destroy = true
  policy        = <<POLICY
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.root_domain_name}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::${var.accountId}:distribution/${aws_cloudfront_distribution.www_distribution.id}"
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
}
locals {
  s3_origin_id = "myS3Origin"
}
/*************cloudfront creation**********************/
//Cloudfront Creation
resource "aws_cloudfront_origin_access_control" "s3-oac" {
  name                              = "s3-oac"
  description                       = "oac Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_cloudfront_distribution" "www_distribution" {
  origin {
    domain_name = "${var.root_domain_name}.s3.${var.myregion}.amazonaws.com"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3-oac.id
    origin_id = var.root_domain_name
  }

  enabled             = true
  default_root_object = "index.html"

  // All values are defaults from the AWS console.
  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id = var.root_domain_name
    min_ttl                = 1
    default_ttl            = 86400
    max_ttl                = 31536000
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  // create aliases for cloudfront 
  aliases = ["${var.www_domain_name}", "${var.root_domain_name}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  // Here's where our certificate is loaded in!
  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = "${data.aws_acm_certificate.issued.arn}" # this is used to pull existing cert into build
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
