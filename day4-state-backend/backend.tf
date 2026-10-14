terraform {
  backend "s3" {
    bucket         = "wavrocktcs"
    key            = "wav/terraform.tfstate" 
    region         = "us-west-2"
    encrypt        = true
    #dynamodb_table = "your-terraform-lock-table"              # Partition key must be 'LockID'
  }
}
