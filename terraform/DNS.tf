resource "yandex_dns_zone" "devops-3-zone" {
  name        = "devops-3-zone"
  description = "Production DNS zone for ${var.domain_address}"
  zone        = "${var.domain_address}."
  # public      = true
}

resource "yandex_dns_recordset" "alb-record" {
  zone_id = yandex_dns_zone.devops-3-zone.id
  name    = "${var.domain_address}."
  type    = "A"
  ttl     = 600
  data    = [yandex_vpc_address.devops-3-external-static-ip.external_ipv4_address[0].address]
}
