terraform {
  backend "s3" {
    bucket = "terraform-state-victor"
    key    = "terraform-jenkins-project.tfstate"
    region = "us-east-1"
  }
}
