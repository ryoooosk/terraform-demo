terraform {
  backend "s3" {
    bucket       = "terraform-state-idoooochi"
    key          = "090_vpc/ecr.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
