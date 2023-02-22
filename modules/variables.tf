//General Variables 
variable "environment_name" {
  description = "Deployment environment (dev/staging/production)"
  type        = string
  default     = "dev"
}

// www. domain name
variable "www_domain_name" {
  default = "www.donsafar.com"
}

// root domain name
variable "root_domain_name" {
  default = "donsafar.com"
}

//api custom domain name
variable "api_name" {
  default = "api.donsafar.com"
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
  default = "CounterDB"
}

#DynamoDR Table items
variable "DBItems" {
  default = <<ITEM
{
  "Id":{"S": "1"},
  "Count": {"N": "0"},
  "Increase": {"N": "1"}
}
ITEM
}

variable "DBhashkey" {
  default = "Id"
}

variable "DBbillingmode" {
  default = "PAY_PER_REQUEST"
}

variable "DBattribute_name" {
  default = "Id"
}

variable "DBattribute_type" {
  default = "S"
}

# Find a certificate that is issued in AWS
data "aws_acm_certificate" "issued" {
  domain   = "${var.root_domain_name}"
  statuses = ["ISSUED"]
}
