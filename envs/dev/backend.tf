terraform {
  backend "s3" {
    bucket = "backenddb-terraform"
    key    = "state"
    region = "us-east-1"
    #dynamodb_table = "backend-db"
    use_lockfile = true
  }
}