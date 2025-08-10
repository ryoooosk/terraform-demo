terraform {
  backend "s3" {
    bucket       = "terraform-state-idoooochi"
    key          = "090_vpc/vpc.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
