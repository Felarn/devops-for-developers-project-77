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

variable "yc_zone" {
  description = "Yandex Cloud zone to deploy resources"
  type        = string
  sensitive   = false
}

variable "yc_os_image_id" {
  description = "yandex cloud id for Operating System image"
  type        = string
  sensitive   = false
}

variable "local_ssh_path" {
  description = "path to public ssh key on local machine"
  type        = string
  sensitive   = false
}

variable "db_name" {
  description = "Name of the postgreSQL database"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "Name of the postgreSQL database user"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the postgreSQL database user"
  type        = string
  sensitive   = true
}
