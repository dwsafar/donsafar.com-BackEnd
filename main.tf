terraform {
/************************************************************************************************************
#bootstrap S3 statefile bucket and DyanmoDB for lock file first then uncomment this after resources created.
 backend "s3" {
    bucket         = "terraform-state-file-site"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking-site"
    encrypt        = true
  }
*************************************************************************************************************/
  required_providers{
    aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"        
    }
  }
}
 provider "aws" {
    region ="${var.myregion}"   
 }

# s3 bucket created for backend tfstate file
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-file-site"
  force_destroy = true  
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
}  
# DynamoDB created for for ttlock file
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking-site"
  billing_mode = "${var.DBbillingmode}"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }   
}

module "backend_modules"{
  source = "./modules"
}