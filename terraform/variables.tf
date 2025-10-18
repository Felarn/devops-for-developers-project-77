variable "yc_folder_id" {
  description = "working folder id in Yandex Cloud"
  type        = string
  sensitive   = false
}

variable "yc_token" {
  description = "Yandex Cloud API token"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Yandex Cloud zone to deploy resources"
  type        = string
  sensitive   = false
}

variable "os_image_id" {
  description = "yandex cloud id for Operating System image"
  type        = string
  sensitive   = false
}

variable "ssh_path" {
  description = "path to public ssh key on local machine"
  type        = string
  sensitive   = false
}
