variable "service_name" {
  description = "サービス名"
  type        = string
}

variable "env" {
  description = "環境識別子（dev, stg, prod）"
  type        = string
}

variable "role" {
  description = "リポジトリに格納するイメージのサービス内でのロール"
  type        = string
}

variable "image_tag_mutability" {
  description = <<DESC
  タグの上書きを許容するか否かを指定します。
  - `MUTABLE` 上書き可能
  - `IMMUTABLE` 上書き不可
  DESC
  type        = string
  default     = "MUTABLE"
}

variable "repository_lifecycle_policy" {
  description = <<DESC
  リポジトリのライフサイクルポリシーをjson形式で指定します。デフォルト値を指定した場合は、
  タグのないイメージのうちプッシュから30日以上経過したイメージを削除します。
  具体的な記述内容は`lifecycle_policy/default_policy.json` を参照してください。
  参考：https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/LifecyclePolicies.html
  DESC
  type        = string
  default     = <<DEFAULT
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Expire untagged images older than 30 days",
        "selection": {
          "tagStatus": "untagged",
          "countType": "sinceImagePushed",
          "countUnit": "days",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
DEFAULT
}

