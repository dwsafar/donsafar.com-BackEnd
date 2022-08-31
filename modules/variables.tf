// www. domain
variable "www_domain_name" {
  default = "www.donsafar.com"
}

// root domain).
variable "root_domain_name" {
  default = "donsafar.com"
}

//region
variable "myregion" {
  default = "us-east-1"
  }

//aws account  
  variable "accountId" {
 default = "378876193119"
  }

//DynamoDB name  
variable "DBname" {
  default = "VisitorCountDB"
  }
/*
// SSL cert for cloudfront https
variable "cloudfront_ssl_acm_arn" {
  default = "data.aws_acm_certificate.issued.arn"
}

// SSL cert for API domain name
variable "cloudfront_ssl_api_arn" {
  default = "data.aws_acm_certificate.aci_issued.arn"
}
*/
# Find a certificate that is issued for cloudfront
data "aws_acm_certificate" "issued" {
  domain   = "donsafar.com"
  statuses = ["ISSUED"]
}

# Find a certificate that is issued for api
data "aws_acm_certificate" "aci_issued" {
  domain   = "api.donsafar.com"
  statuses = ["ISSUED"]
}

 data "aws_cloudfront_distribution" "test" {
  id = aws_cloudfront_distribution.www_distribution.id
}