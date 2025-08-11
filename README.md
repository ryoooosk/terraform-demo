# terraform-demo

このリポジトリは、AWSインフラストラクチャをTerraformで管理するためのサンプルプロジェクトです。

## セットアップと利用方法

1. [Terraform](https://www.terraform.io/downloads.html) v1.12.2以上をインストールしてください。
2. AWSアカウントを用意し、認証情報を環境変数または `~/.aws/credentials` で設定してください。
   - 例（zshの場合）:

     ```zsh
     export AWS_ACCESS_KEY_ID=あなたのアクセスキーID
     export AWS_SECRET_ACCESS_KEY=あなたのシークレットアクセスキー
     export AWS_DEFAULT_REGION=ap-northeast-1
     ```

3. 初期化:

   ```sh
   terraform init
   ```

    **補足:**
    `terraform init` は、初回実行時だけでなく、プロバイダーやモジュールの追加・変更、バックエンド設定の変更、Terraformバージョンアップ時などにも再実行が必要です。
    コマンド実行時に「初期化が必要」と表示された場合も再度実行してください。

4. プラン作成:

   ```sh
   terraform plan -var-file=env/dev.tfvars
   ```

5. 適用:

   ```sh
   terraform apply -var-file=env/dev.tfvars
   ```

## バリデーションについて

`terraform validate` コマンドを使うことで、Terraform構成ファイルの文法や基本的なエラーを事前にチェックできます。
リソース作成前に実行することを推奨します。

---

## バックエンドのステート管理について

本プロジェクトでは、Terraformの状態（state）ファイルをS3バケットで管理しています。
設定例は `terraform.tf` を参照してください。

## モジュール概要

- VPC・サブネット・ルートテーブル等のネットワーク関連リソース（modules/vpc/）
- ECSクラスター関連リソース（modules/ecs/）
- ECRリポジトリとライフサイクルポリシー（modules/ecr/）
