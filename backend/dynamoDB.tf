resource "aws_dynamodb_table" "state_locking" {
  name           = "adeyomola_dynamodb"
  hash_key       = "LockID"
  read_capacity  = 10
  write_capacity = 10
  attribute {
    name = "LockID"
    type = "S"
  }
}
