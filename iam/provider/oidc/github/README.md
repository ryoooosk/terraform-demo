# Terraformステート概要

このディレクトリでは、GitHub OIDCプロバイダーのIAMリソースをTerraformで管理しています。

- `resources.tf` で `iam_oidc_provider` モジュールを呼び出し、必要なIAM OIDCプロバイダーの設定を行います。
- `terraform.tfstate` ファイルには、このディレクトリ配下で管理されているリソースの現在の状態（ステート）が保存されます。
- ステートファイルは、Terraformの実行ごとにリソースの作成・変更・削除履歴を記録し、インフラの一貫性を保ちます。
- ステートファイルは機密情報を含む場合があるため、管理・保護に注意してください。

## 参考

- モジュールの詳細は [`modules/iam/provider/oidc/github`](../../../../modules/iam/provider/oidc/github) を参照してください。
