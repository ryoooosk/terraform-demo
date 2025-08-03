## terraform-demo

このリポジトリは、Terraformを用いてAWS上にVPC（Virtual Private Cloud）を構築するためのサンプルです。

### 構成ファイル一覧

- `terraform.tf` : Terraformのバックエンド（S3）設定。
- `variables.tf` : VPCやタグなどの変数定義。
- `vpc.tf` : VPCリソースの作成。
- `env/dev.tfvars` : 開発環境用の変数ファイル。

### 利用方法

1. AWS認証情報をローカル環境変数に設定してください。
   以下のコマンドをターミナルで実行します（zshの場合）：

   ```zsh
   export AWS_ACCESS_KEY_ID=あなたのアクセスキーID
   export AWS_SECRET_ACCESS_KEY=あなたのシークレットアクセスキー
   export AWS_DEFAULT_REGION=ap-northeast-1 # 例: 東京リージョン
   ```

2. `terraform init` で初期化。
3. `terraform plan -var-file=env/dev.tfvars` で内容確認。
4. `terraform apply -var-file=env/dev.tfvars` でVPCを作成。

### 必要なツール

- Terraform v1.12.2以上
- AWSアカウント
