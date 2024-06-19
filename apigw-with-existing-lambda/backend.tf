terraform {
  backend "s3" {
    bucket         = "terraform-backend"
    key            = "apigw/payments-app.state.lock"
    region         = "us-east-1"
    dynamodb_table = "terraform-backend"
  }
}