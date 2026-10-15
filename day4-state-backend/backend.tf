terraform {
  backend "s3" {
    bucket         = "wavrocktcs"
    key            = "wav/terraform.tfstate" 
    region         = "us-west-2"
    encrypt        = true
    #use_lockfile   = true #s3 native locking supported version 1.0.0 and above 
    dynamodb_table = "your-terraform-lock-table"              # Partition key must be 'LockID'
  }
}
