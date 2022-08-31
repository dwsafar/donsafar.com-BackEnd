resource "aws_dynamodb_table" "VisitorCountDB" {
  name         = "${var.DBname}"
  hash_key     = "Id"
  billing_mode = "PAY_PER_REQUEST"  
  attribute {
    name = "Id"
    type = "S"
  }
}
resource "aws_dynamodb_table_item" "VisitorCountDB" {
  table_name   = aws_dynamodb_table.VisitorCountDB.name
  hash_key     = aws_dynamodb_table.VisitorCountDB.hash_key
  
   item = <<ITEM
{
  "Id":{"S": "1"},
  "Count": {"N": "0"},
  "Increase": {"N": "1"}
}
ITEM
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-${var.root_domain_name}-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
    lifecycle {
    prevent_destroy = true
  }
}
