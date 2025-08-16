<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.cluster_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_additional_tags"></a> [cluster\_additional\_tags](#input\_cluster\_additional\_tags) | ECSクラスターに付与したい追加タグ | `map(string)` | `{}` | no |
| <a name="input_env"></a> [env](#input\_env) | 環境識別子（dev, stg, prod） | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | ECSクラスターを作成するサービス名 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | 作成されたクラスターのARN |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | 作成されたクラスターの名前 |
<!-- END_TF_DOCS -->