// security groups
resource "yandex_vpc_security_group" "devops-3-balancer" {
  name        = "devops-3-balancer"
  description = "Security group for Balancer"
  network_id  = yandex_vpc_network.devops-3-net.id

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"
    description       = "healthchecks"
    port              = 30080
    predefined_target = "loadbalancer_healthchecks"
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "devops-3-appservers" {
  name        = "devops-3-appservers"
  description = "Security group for App Servers"
  network_id  = yandex_vpc_network.devops-3-net.id

  ingress {
    protocol       = "TCP"
    description    = "SSH access"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"
    description       = "balancer"
    port              = 80
    security_group_id = yandex_vpc_security_group.devops-3-balancer.id
  }

  ingress {
    protocol       = "TCP"
    description    = "temp-home"
    port           = 80
    v4_cidr_blocks = ["46.39.249.0/24"]
  }

  ingress {
    protocol          = "TCP"
    description       = "temp for future App"
    port              = 3000
    security_group_id = yandex_vpc_security_group.devops-3-balancer.id
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "devops-3-sql" {
  name        = "devops-3-sql"
  description = "Security group for PostgreSQL cluster"
  network_id  = yandex_vpc_network.devops-3-net.id

  ingress {
    protocol          = "ANY"
    description       = "app-servers"
    from_port         = 0
    to_port           = 65535
    security_group_id = yandex_vpc_security_group.devops-3-appservers.id
  }
}
