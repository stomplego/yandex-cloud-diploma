resource "yandex_iam_service_account" "k8s_sa" {
  name = "k8s-cluster-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_sa_roles" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

resource "yandex_iam_service_account" "k8s_node_sa" {
  name = "k8s-node-sa"
}
