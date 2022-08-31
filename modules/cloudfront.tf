//OAC for Cloudfront
resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "OAC for S3"
  lifecycle {
    prevent_destroy = true
  }
}
//Cloudfront Creation

resource "aws_cloudfront_distribution" "www_distribution" {
  origin {
    domain_name = "${var.root_domain_name}.s3.${var.myregion}.amazonaws.com"
    origin_id = var.root_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
    }
    
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
    acm_certificate_arn      = data.aws_acm_certificate.issued.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
    lifecycle {
    prevent_destroy = true
  }
}
