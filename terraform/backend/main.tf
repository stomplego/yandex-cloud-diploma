# 1. Сервисный аккаунт для Terraform
resource "yandex_iam_service_account" "terraform_sa" {
  name        = "terraform-sa"
  description = "Service account for Terraform infrastructure management"
}

# 2. Назначаем роли (минимально необходимые, без суперпользователя)
resource "yandex_resourcemanager_folder_iam_member" "sa_roles" {
  for_each = toset([
    "editor",                    # базовое управление ресурсами
    "storage.admin",             # для создания бакета и записи стейта
    "k8s.clusters.agent",        # для создания K8s кластера
    "vpc.publicAdmin",           # для работы с сетью
    "container-registry.admin",  # для Container Registry
  ])
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.terraform_sa.id}"
}

# 3. Статический ключ доступа для S3 backend
resource "yandex_iam_service_account_static_access_key" "sa_key" {
  service_account_id = yandex_iam_service_account.terraform_sa.id
  description        = "static access key for terraform backend"
}

# 4. S3-бакет для хранения state
resource "yandex_storage_bucket" "tf_state" {
  bucket    = "diploma-tfstate-${var.folder_id}"
  folder_id = var.folder_id
  max_size  = 1073741824

  versioning {
    enabled = true
  }
}

# 5. Автоматически генерируем файл backend.tf для папки infrastructure
resource "local_file" "backend_config" {
  filename = "${path.module}/../infrastructure/backend.tf"
  content  = <<-EOT
    terraform {
      backend "s3" {
        endpoint                    = "https://storage.yandexcloud.net"
        bucket                      = "${yandex_storage_bucket.tf_state.bucket}"
        region                      = "ru-central1"
        key                         = "infrastructure/terraform.tfstate"
        access_key                  = "${yandex_iam_service_account_static_access_key.sa_key.access_key}"
        secret_key                  = "${yandex_iam_service_account_static_access_key.sa_key.secret_key}"
        skip_region_validation      = true
        skip_credentials_validation = true
        skip_requesting_account_id  = true
        skip_s3_checksum            = true
      }
    }
  EOT
}
