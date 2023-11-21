terraform {
  backend "s3" {
    bucket = "probable-couscous"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}