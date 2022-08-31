#The configuration for the `remote` backend.
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-state-donsafar.com"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-state-donsafar.com-locks"
    encrypt        = true
  }
    required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  }
  module "DynamoDB" {
    source = "./modules"    
  }
   module "s3" {
    source = "./modules"    
  }
   module "route53" {
    source = "./modules"    
  }
   module "variables" {
    source = "./modules"    
  }
   module "cloudfront" {
    source = "./modules"    
  }
   module "Api" {
    source = "./modules"    
  }
   module "Lambda" {
    source = "./modules"    
  }
