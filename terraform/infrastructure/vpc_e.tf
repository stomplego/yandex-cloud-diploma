resource "yandex_vpc_subnet" "subnet_e" {
  name           = "diploma-subnet-e"
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.diploma_net.id
  v4_cidr_blocks = ["10.4.0.0/24"]
}
