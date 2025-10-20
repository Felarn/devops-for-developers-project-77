// database
resource "yandex_mdb_postgresql_cluster" "devops-3-postgresql-cluster" {
  name                = "devops-3-postgresql-cluster"
  environment         = "PRODUCTION"
  network_id          = yandex_vpc_network.devops-3-net.id
  security_group_ids  = [yandex_vpc_security_group.devops-3-sql.id]
  deletion_protection = false

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 22
  }

  config {
    version = 16
    resources {
      resource_preset_id = "c3-c2-m4" # 2 vCPU, 4GB RAM
      disk_type_id       = "network-hdd"
      disk_size          = 10
    }
  }

  host {
    zone             = var.yc_zone
    name             = "PostgreSQL"
    subnet_id        = yandex_vpc_subnet.devops-3-subnet.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_postgresql_user" "db_user" {
  cluster_id = yandex_mdb_postgresql_cluster.devops-3-postgresql-cluster.id
  name       = var.db_user
  password   = var.db_password
}

resource "yandex_mdb_postgresql_database" "db_name" {
  cluster_id = yandex_mdb_postgresql_cluster.devops-3-postgresql-cluster.id
  name       = var.db_name
  owner      = var.db_user
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"

  depends_on = [yandex_mdb_postgresql_user.db_user]
}
