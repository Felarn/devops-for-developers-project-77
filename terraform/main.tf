terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    datadog = {
      source = "DataDog/datadog"

    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone      = var.yc_zone
  token     = var.yc_token
  folder_id = var.yc_folder_id
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}
