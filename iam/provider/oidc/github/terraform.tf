terraform {
  backend "s3" {
    bucket       = "terraform-state-idoooochi"
    key          = "iam/oidc/github.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
