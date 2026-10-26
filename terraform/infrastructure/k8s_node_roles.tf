resource "yandex_resourcemanager_folder_iam_member" "k8s_node_sa_roles" {
  for_each = toset([
    "container-registry.images.puller",
    "vpc.publicAdmin",
    "load-balancer.admin",
  ])
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.k8s_node_sa.id}"
}
