#create Dynamo DB
## refer to variables.tf 

resource "aws_dynamodb_table" "DynamoTable" {
  name         = var.DBname
  hash_key     = var.DBhashkey
  billing_mode = var.DBbillingmode
  attribute {
    name = var.DBattribute_name
    type = var.DBattribute_type
  }
}
resource "aws_dynamodb_table_item" "DynamoTable" {
  table_name = aws_dynamodb_table.DynamoTable.name
  hash_key   = aws_dynamodb_table.DynamoTable.hash_key
  item       = var.DBItems
}
