locals {
  iam_role_tags = merge(
    var.iam_role_additional_tags,
    {
      ServiceName = var.service_name
      Env         = var.env
    }
  )
}

data "aws_caller_identity" "caller_identity" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"
    # GitHub Actionsのsts:AssumeRoleWithWebIdentityアクションを使った、一時的な認証情報の取得を許可
    principals {
      type = "Federated" # フェデレーテッド（OIDC）認証を利用
      identifiers = [
        # AWSアカウントIDに紐づくGitHub OIDCプロバイダーARN（Amazon Resource Name）
        "arn:aws:iam::${data.aws_caller_identity.caller_identity.account_id}:oidc-provider/token.actions.githubusercontent.com"
      ]
    }

    # Security Token Service（STS）が提供するアクション
    actions = [
      "sts:AssumeRoleWithWebIdentity" # 外部IDプロパイダーで認証されたユーザーやサービスが、AWSのIAMロールを一時的に引き受けるために使われる。
    ]
    # subクレームが指定したGitHub リポジトリに一致することを要求
    condition {
      test     = "Stringlike"                              # 文字列パターン一致による条件
      variable = "token.actions.githubusercontent.com:sub" # トークンが発行されたユーザーやサービスを一意に識別するために値（OIDCトークンのsubクレーム）
      # 変数を使ってAWSへのアクセス権限を付与したいGitHub Actionsワークフローの含まれるGitHub Organizationとリポジトリを指定できるように
      values = [
        "repo:${var.github_organization_name}/${var.github_repository_name}:*" # 指定リポジトリからのアクセスのみ許可
      ]
    }

    # audクレームがsts.amazonaws.comであることも要求
    condition {
      test     = "StringEquals"                            # 完全一致による条件
      variable = "token.actions.githubusercontent.com:aud" # OIDCトークンが度のサービス向けに発行されたかを示す値（OIDCトークンのaudクレーム）
      values = [
        "sts.amazonaws.com" # AWS STSのみを許可
      ]
    }
  }
}

resource "aws_iam_role" "role" {
  name = "${var.service_name}-${var.env}-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}
