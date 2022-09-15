//General Variables 
variable "environment_name" {
  description = "Deployment environment (dev/staging/production)"
  type        = string
  default     = "dev"
}

// www. domain name
variable "www_domain_name" {
  default = "www.test.com"
}

// root domain name
variable "root_domain_name" {
  default = "test.com"
}

//api custom domain name
variable "api_name" {
  default = "api.test.com"  
}

//region 
variable "myregion" {
  default = "us-east-1"
  }

//aws account  
variable "accountId" {
  default = "12334333"
  }

//DynamoDB name  
variable "DBname" {
  default = "MyDBName"
  }

#DynamoDR Table items
variable "DBItems" {
 default   = <<ITEM
{
  "Id":{"S": "1"},
  "Count": {"N": "0"},
  "Increase": {"N": "1"}
}
ITEM
}

variable "DBhashkey" {
  default  = "Id"
}

variable "DBbillingmode" {
  default   = "PAY_PER_REQUEST"
}

variable "DBattribute_name" {
  default   = "Id"
}

variable "DBattribute_type" {
  default   = "S"
}