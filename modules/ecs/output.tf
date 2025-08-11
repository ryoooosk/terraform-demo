output "cluster_name" {
  description = "作成されたクラスターの名前"
  value       = aws_ecs_cluster.cluster.name
}

output "cluster_arn" {
  description = "作成されたクラスターのARN"
  value       = aws_ecs_cluster.cluster.arn
}
