terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "tf-state-573055573761"
    key = "state/terraform/new-project"
    encrypt = true
    use_lockfile = true
  }
}