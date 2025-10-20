
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

# resource "yandex_cm_certificate" "devops-3-certificate-tf" {
#   name        = "devops-3-certificate-tf"
#   description = "managed certificate for devops-3 project, created by terraform"
#   domains     = [var.domain_address]

#   managed {
#     challenge_type = "DNS_CNAME"
#   }

# }


// Create a new Certificates for the domain
//
resource "yandex_cm_certificate" "devops-3-certificate" {
  name        = "devops-3-certificate-tf"
  description = "managed certificate for devops-3 project, created by terraform"
  domains     = [var.domain_address]

  managed {
    challenge_type = "DNS_CNAME"
  }
}

resource "yandex_dns_recordset" "devops-3-certificate-challenges" {
  count   = 1
  zone_id = yandex_dns_zone.devops-3-zone.id
  name    = yandex_cm_certificate.devops-3-certificate.challenges[0].dns_name
  type    = yandex_cm_certificate.devops-3-certificate.challenges[0].dns_type
  data    = [yandex_cm_certificate.devops-3-certificate.challenges[0].dns_value]
  ttl     = 60
}
