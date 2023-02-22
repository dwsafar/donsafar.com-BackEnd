terraform {
  backend "s3" {
    bucket         = "tf-state-files-projects"
    key            = "donsafar.com/terraform.tfstate"
    region         = "us-east-1" 
    dynamodb_table = "terraform-lock-hcl"
  }
}
