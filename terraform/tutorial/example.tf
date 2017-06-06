provider "aws" {
  access_key = "AKIAJUD646FPSRPT3VSA"
  secret_key = "kdFIO3h/6TXNeF6EuvbP6UHrjRamw+Gjj2zzv9n4"
  region     = "ap-northeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-923d12f5"
  instance_type = "t2.micro"
}
