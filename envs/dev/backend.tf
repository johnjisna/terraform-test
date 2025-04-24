terraform {
  backend "s3" {
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
    region = var.remote_state_region
    #dynamodb_table = "backend-db"
    use_lockfile = true
  }
}
