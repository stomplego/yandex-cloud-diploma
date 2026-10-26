resource "yandex_kubernetes_node_group" "worker_group" {
  cluster_id = yandex_kubernetes_cluster.diploma_k8s.id
  name       = "worker-nodes"

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores  = 2
      memory = 4
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      subnet_ids         = [yandex_vpc_subnet.subnet_e.id]
      security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
      nat                = true
    }

    boot_disk {
      type = "network-hdd"
      size = 32
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-e"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
  
  timeouts {
    create = "90m"
    update = "90m"
    delete = "30m"
  }

}
