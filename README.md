# terraform-demo

このリポジトリは、AWSインフラストラクチャをTerraformで管理するためのサンプルプロジェクトです。

## セットアップと利用方法

1. [Terraform](https://www.terraform.io/downloads.html) v1.12.2以上をインストールしてください。
2. AWSアカウントを用意し、認証情報を環境変数または `~/.aws/credentials` で設定してください。
   - 環境変数の場合

     ```zsh
     export AWS_ACCESS_KEY_ID=あなたのアクセスキーID
     export AWS_SECRET_ACCESS_KEY=あなたのシークレットアクセスキー
     export AWS_DEFAULT_REGION=ap-northeast-1
     ```

   - `~/.aws/credentials` ファイルの場合

     ```ini
     [default]
     aws_access_key_id = あなたのアクセスキーID
     aws_secret_access_key = あなたのシークレットアクセスキー


3. 本プロジェクトは「dev」環境（`env/dev.tfvars`）を前提としています。

   Terraformの「ワークスペース」は、同じ構成ファイルで複数の独立した状態（state）を管理できる機能です。
   このプロジェクトでは「dev」ワークスペースを利用しています。
   （`terraform workspace select dev` で dev ワークスペースを選択してください）
   環境ごとに状態ファイルを分けたい場合は、以下のコマンドでワークスペースを作成・切り替えできます。

   ```sh
   terraform workspace new <workspace名>   # 新規作成
   terraform workspace select <workspace名> # 切り替え
   ```

   例えば、dev以外の環境（例: prod）を利用したい場合は、

   1. `terraform workspace new prod` でワークスペースを作成
   2. `terraform workspace select prod` で切り替え
   3. `terraform plan -var-file=env/prod.tfvars` などで適用

4. 初期化:

   ```sh
   terraform init
   ```

    **補足:**
    `terraform init` は、初回実行時だけでなく、プロバイダーやモジュールの追加・変更、バックエンド設定の変更、Terraformバージョンアップ時などにも再実行が必要です。
    コマンド実行時に「初期化が必要」と表示された場合も再度実行してください。

5. プラン作成:

   ```sh
   terraform plan -var-file=env/dev.tfvars
   ```

6. 適用:

   ```sh
   terraform apply -var-file=env/dev.tfvars
   ```

### バリデーションについて

`terraform validate` コマンドを使うことで、Terraform構成ファイルの文法や基本的なエラーを事前にチェックできます。
リソース作成前に実行することを推奨します。

### GitHub ActionsでECRへプッシュするためのIAMロール設定

`.github/workflows/build-and-push-container-image.yml`のGitHub ActionsワークフローでECRへイメージをプッシュします。
そのためにmodules/iam/role/oidc/github で作成されるIAMロールのARNをGitHubリポジトリのSecretsに登録してください。

## バックエンドのステート管理について

本プロジェクトでは、Terraformの状態（state）ファイルをS3バケットで管理しています。
設定例は `terraform.tf` を参照してください。

## Terraformの基本ブロック

### resource

TerraformでAWSなどのリソースを作成する基本単位です。

例：

```hcl
resource "aws_s3_bucket" "example" {
   bucket = "my-example-bucket"
   acl    = "private"
}
```

リソースブロックでは、リソース固有の設定値（引数）を指定します。例えば、`aws_s3_bucket`の場合は`bucket`や`acl`などが該当します。
通常引数は、リソースごとに異なり、公式ドキュメントで詳細を確認できます。

メタ引数は、Terraformリソースの作成や管理の挙動を柔軟に制御するための特別な引数です。主なメタ引数には以下があります。

- `depends_on`: 他のリソースへの依存関係を明示的に指定できます。これにより、指定したリソースが先に作成・変更されることを保証します。
- `count`: 同じリソースを複数個まとめて作成したい場合に使います。数値を指定することで、その数だけリソースが生成されます。
- `for_each`: リストやマップを使って、複数のリソースを一括で作成できます。`count`より柔軟に個別管理が可能です。
- `lifecycle`: リソースの作成・削除・更新の挙動を細かく制御できます。例えば、`prevent_destroy`で削除防止、`ignore_changes`で特定属性の変更を無視するなどの設定ができます。

これらのメタ引数を活用することで、インフラ構成の自動化や管理がより効率的になります。

### data

Terraform外（または別のTerraformステート）で管理されているリソースの情報を取得するためのブロックです。
resourceと同様に、属性とその値を与えて一意のデータとして取得。

例：

```hcl
data "aws_ami" "latest" {
   most_recent = true
   owners      = ["amazon"]
   filter {
      name   = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
   }
}
```

### variable

外部から値を受け取るための変数定義です。
例：

```hcl
variable "instance_type" {
   description = "EC2インスタンスタイプ"
   type        = string
   default     = "t3.micro"
}
```

### local

一時的な値や式を定義するためのローカル変数です。
例：

```hcl
locals {
   bucket_name = "my-bucket-${var.env}"
}
```

### output

リソースや変数の値を出力するためのブロック

1. 生成されたリソースなどの値をapply時に確認できる
2. モジュール内で生成された値をモジュール外で利用できる
3. 生成された値をリモートステートとして読み取りできる

例：

```hcl
output "bucket_id" {
   value = aws_s3_bucket.example.id
}
```

### module

複数のリソースや設定をまとめて再利用できる単位です。
例：

```hcl
module "vpc" {
   source = "terraform-aws-modules/vpc/aws"
   name   = "my-vpc"
   cidr   = "10.0.0.0/16"
}
```

### provider

AWSやGCPなど、どのクラウドサービスを使うかを指定します。
例：

```hcl
provider "aws" {
   region = "ap-northeast-1"
}
```

## Terraformの基本文法

### for_each

複数リソースを一括作成する際に使います。
例：

```hcl
resource "aws_s3_bucket" "multi" {
   for_each = {
     a = "alpha"
     b = "bravo"
     c = "charlie"
   }
   bucket = "my-bucket-${each.key}-${each.value}"
}
```

### for

リストやマップをループ処理して値を生成します。
例：

```hcl
locals {
   bucket_names = [for name in ["a", "b", "c"] : "my-bucket-${name}"]
}
```

### 三項演算子（条件分岐）

条件によって値を切り替えることができます。
例：

```hcl
variable "is_prod" { default = false }
locals {
   instance_type = var.is_prod ? "m5.large" : "t3.micro"
}
```

## terraform-docs

`terraform-docs`は、Terraformの構成ファイル（.tf）から自動的にドキュメントを生成するツールです。主に変数・出力・リソース・モジュールなどの情報をMarkdownやHTMLなどの形式で出力でき、READMEの自動更新やインフラ構成の可視化に役立ちます。

### 使い方例

1. インストール（Homebrewの場合）:

   ```sh
   brew install terraform-docs
   ```

2. ドキュメント生成:

   ```sh
   terraform-docs <FORMAT> <PATH>
   ```

   主な引数・オプション

   - `<FORMAT>`  
      出力形式を指定します。例: `markdown`, `md`, `json`, `yaml`, `html` など。
   - `<PATH>`  
      ドキュメント化したいTerraformディレクトリを指定します。例: `.`（カレントディレクトリ）
   - `--output-file README.md`  
      生成したドキュメントを指定ファイルに出力します。
   - `--sort-by-required`  
      変数の必須・任意順でソートします。
   - `--show`  
      表示する項目をカスタマイズできます。例: `--show inputs,outputs,providers,modules,resources`
   - `--config <file>`  
      独自の設定ファイル（YAML）で出力内容を制御できます。
