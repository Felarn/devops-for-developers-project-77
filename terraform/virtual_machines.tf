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
    subnet_id          = yandex_vpc_subnet.devops-3-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.devops-3-appservers.id]
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      datasource:
        Ec2:
          strict_id: false
      ssh_pwauth: no
      users:
        - name: ${var.vm_admin_username}
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file(var.local_ssh_path)}
      EOF
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
    subnet_id          = yandex_vpc_subnet.devops-3-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.devops-3-appservers.id]
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      datasource:
        Ec2:
          strict_id: false
      ssh_pwauth: no
      users:
        - name: ${var.vm_admin_username}
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file(var.local_ssh_path)}
      EOF
  }

  depends_on = [yandex_mdb_postgresql_cluster.devops-3-postgresql-cluster, yandex_mdb_postgresql_database.db_name]
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
