
// router

resource "yandex_alb_http_router" "devops-3-router" {
  name = "devops-3-router"
}


// Application Load Balancer (ALB)

resource "yandex_alb_load_balancer" "devops-3-load-balancer" {
  name               = "devops-3-load-balancer"
  network_id         = yandex_vpc_network.devops-3-net.id
  security_group_ids = [yandex_vpc_security_group.devops-3-balancer.id]

  allocation_policy {
    location {
      zone_id   = var.yc_zone
      subnet_id = yandex_vpc_subnet.devops-3-subnet.id
    }
  }

  listener {
    name = "devops-3-http-listener"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.devops-3-external-static-ip.external_ipv4_address[0].address
        }
      }
      ports = [8080, 80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.devops-3-router.id
      }
    }
  }

  listener {
    name = "devops-3-listener-https"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.devops-3-external-static-ip.external_ipv4_address[0].address
        }
      }
      ports = [443]
    }
    tls {
      default_handler {
        http_handler {
          http_router_id = yandex_alb_http_router.devops-3-router.id
        }
        certificate_ids = [yandex_cm_certificate.devops-3-certificate.id]
      }
      sni_handler {
        name         = "devops3-sni"
        server_names = ["devops-3.felarn-project.ru"]
        handler {
          http_handler {
            http_router_id = yandex_alb_http_router.devops-3-router.id
          }
          certificate_ids = [yandex_cm_certificate.devops-3-certificate.id]
        }
      }
    }
  }

  log_options {
    disable = true
  }
}



// целевая группа

resource "yandex_alb_target_group" "devops-3-target-group" {
  name = "devops-3-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.devops-3-subnet.id
    ip_address = yandex_compute_instance.vm-1.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.devops-3-subnet.id
    ip_address = yandex_compute_instance.vm-2.network_interface.0.ip_address
  }
}


// backend group

resource "yandex_alb_backend_group" "devops-3-backend-group" {
  name = "devops-3-backend-group"

  http_backend {
    name             = "devops-3-backend"
    weight           = 1
    port             = 3000
    target_group_ids = [yandex_alb_target_group.devops-3-target-group.id]
    healthcheck {
      timeout             = "1s"
      interval            = "1s"
      healthy_threshold   = 1
      unhealthy_threshold = 1
      healthcheck_port    = 3000
      http_healthcheck {
        path = "/"
      }
    }
  }
}

// virtual host

resource "yandex_alb_virtual_host" "devops-3-host" {
  name           = "devops-3-host"
  http_router_id = yandex_alb_http_router.devops-3-router.id

  route {
    name = "devops-3-route"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.devops-3-backend-group.id
        timeout           = "60s"
        auto_host_rewrite = false
      }
    }
  }
  authority = ["devops-3.felarn-project.ru"]
}
