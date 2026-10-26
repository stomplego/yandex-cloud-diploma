output "cluster_id" {
  value = yandex_kubernetes_cluster.diploma_k8s.id
}

output "cluster_external_endpoint" {
  value = yandex_kubernetes_cluster.diploma_k8s.master[0].external_v4_endpoint
}
