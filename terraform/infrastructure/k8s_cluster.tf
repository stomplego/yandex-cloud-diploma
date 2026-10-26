resource "yandex_kubernetes_cluster" "diploma_k8s" {
  name        = "diploma-k8s-cluster"
  description = "Diploma Kubernetes cluster"
  network_id  = yandex_vpc_network.diploma_net.id

  master {
    zonal {
      zone      = "ru-central1-e"
      subnet_id = yandex_vpc_subnet.subnet_e.id
    }
    public_ip = true
  }

  service_account_id      = yandex_iam_service_account.k8s_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_node_sa.id

  release_channel = "STABLE"

  timeouts {
    create = "90m"
    update = "90m"
    delete = "30m"
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_sa_roles,
    yandex_resourcemanager_folder_iam_member.k8s_node_sa_roles,
  ]
}
