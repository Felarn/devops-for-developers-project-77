
resource "yandex_vpc_address" "devops-3-external-static-ip" {
  name = "devops-3-external-static-ip"

  external_ipv4_address {
    zone_id = var.yc_zone
  }
}

# resource "yandex_vpc_address" "devops-3-service-ip" {
#   name = "devops-3-service-ip"

#   external_ipv4_address {
#     zone_id = var.yc_zone
#   }
# }

// networks
resource "yandex_vpc_network" "devops-3-net" {
  folder_id = var.yc_folder_id
}

resource "yandex_vpc_subnet" "devops-3-subnet" {
  name           = "devops-3-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.devops-3-net.id
  v4_cidr_blocks = ["10.5.0.0/24"]
  folder_id      = var.yc_folder_id
}
