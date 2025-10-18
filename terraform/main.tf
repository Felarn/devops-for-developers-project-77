terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone      = var.yc_zone
  token     = var.yc_token
  folder_id = var.yc_folder_id
}

data "yandex_resourcemanager_folder" "project_folder" {
  folder_id = var.yc_folder_id
}

output "folder" {
  value = data.yandex_resourcemanager_folder.project_folder
}

// virtual machines
// # 1 
resource "yandex_compute_instance" "vm-1" {
  name        = "devops-3-vm-1"
  platform_id = "standard-v3"
  zone        = var.yc_zone
  folder_id   = var.yc_folder_id

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk-vm-1.id

  }

  network_interface {
    subnet_id = yandex_vpc_subnet.devops-3-subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${var.local_ssh_path}")}"
  }

  depends_on = [yandex_mdb_postgresql_cluster.devops-3-postgresql-cluster, yandex_mdb_postgresql_database.db_name]
}

// # 2
resource "yandex_compute_instance" "vm-2" {
  name        = "devops-3-vm-2"
  platform_id = "standard-v3"
  zone        = var.yc_zone
  folder_id   = var.yc_folder_id

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk-vm-2.id

  }

  network_interface {
    subnet_id = yandex_vpc_subnet.devops-3-subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${var.local_ssh_path}")}"
  }

  depends_on = [yandex_mdb_postgresql_cluster.devops-3-postgresql-cluster, yandex_mdb_postgresql_database.db_name]
}

// networks
resource "yandex_vpc_network" "devops-3-net" {
  folder_id = var.yc_folder_id
}

resource "yandex_vpc_subnet" "devops-3-subnet" {
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.devops-3-net.id
  v4_cidr_blocks = ["10.5.0.0/24"]
  folder_id      = var.yc_folder_id
}


// disks
resource "yandex_compute_disk" "disk-vm-1" {
  name      = "devops-3-disk-vm-1"
  size      = 8
  type      = "network-hdd"
  zone      = var.yc_zone
  image_id  = var.yc_os_image_id // идентификатор образа Ubuntu
  folder_id = var.yc_folder_id

  labels = {
    environment = "test"
  }
}

resource "yandex_compute_disk" "disk-vm-2" {
  name      = "devops-3-disk-vm-2"
  size      = 8
  type      = "network-hdd"
  zone      = var.yc_zone
  image_id  = var.yc_os_image_id // идентификатор образа Ubuntu
  folder_id = var.yc_folder_id

  labels = {
    environment = "test"
  }
}

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


// balancer

resource "yandex_vpc_security_group" "devops-3-balancer" {
  name        = "devops-3-sg-balancer"
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

// security groups

resource "yandex_vpc_security_group" "devops-3-appservers" {
  name        = "devops-3-sg-appservers"
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
  name        = "devops-3-sg-sql"
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
