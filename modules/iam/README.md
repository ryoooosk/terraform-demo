
## modules/iam ディレクトリ概要

このディレクトリは、AWS IAM（Identity and Access Management）に関連するTerraformモジュールをまとめています。

### provider/oidc/github

GitHub ActionsなどのCI/CDサービスからAWSリソースへ安全にアクセスするためのOIDC（OpenID Connect）プロバイダーを作成・管理するモジュールです。
主な役割：

- GitHub OIDCプロバイダーのリソース（`aws_iam_openid_connect_provider`）をTerraformで定義
- GitHubリポジトリからの認証要求を受け入れるための設定
- AWS側でGitHubのIDトークンを検証できるようにする

このモジュールを利用することで、GitHub ActionsからAWSへの認証情報（シークレットキー等）を直接渡すことなく、安全に権限付与が可能になります。

### role/oidc/github

GitHub OIDCプロバイダー経由でAWSリソースにアクセスするためのIAMロールやポリシーを定義するモジュールです。
主な役割：

- OIDC認証を条件としたIAMロール（`aws_iam_role`）の作成
- 必要な権限（ポリシー）の付与（例：ECRへのpush/pull、S3へのアクセスなど）
- ロールのassume roleポリシーにOIDC条件を追加し、GitHub Actionsからのみ利用可能に制限
- モジュール利用者が必要な権限や条件を柔軟に設定できるよう変数化

このモジュールを使うことで、GitHub Actionsのワークフローごとに最小権限のIAMロールを発行し、セキュアな運用が可能です。
