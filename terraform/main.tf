terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone  = var.zone
  token = var.yc_token
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
  zone        = var.zone
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
    ssh-keys = "ubuntu:${file("${var.ssh_path}")}"
  }
}

// # 2
resource "yandex_compute_instance" "vm-2" {
  name        = "devops-3-vm-2"
  platform_id = "standard-v3"
  zone        = var.zone
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
    ssh-keys = "ubuntu:${file("${var.ssh_path}")}"
  }
}

// networks
resource "yandex_vpc_network" "devops-3-net" {
  folder_id = var.yc_folder_id
}

resource "yandex_vpc_subnet" "devops-3-subnet" {
  zone           = var.zone
  network_id     = yandex_vpc_network.devops-3-net.id
  v4_cidr_blocks = ["10.5.0.0/24"]
  folder_id      = var.yc_folder_id
}


// disks
resource "yandex_compute_disk" "disk-vm-1" {
  name      = "devops-3-disk-vm-1"
  size      = 8
  type      = "network-hdd"
  zone      = var.zone
  image_id  = var.os_image_id // идентификатор образа Ubuntu
  folder_id = var.yc_folder_id

  labels = {
    environment = "test"
  }
}

resource "yandex_compute_disk" "disk-vm-2" {
  name      = "devops-3-disk-vm-2"
  size      = 8
  type      = "network-hdd"
  zone      = var.zone
  image_id  = var.os_image_id // идентификатор образа Ubuntu
  folder_id = var.yc_folder_id

  labels = {
    environment = "test"
  }
}
