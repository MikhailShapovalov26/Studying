terraform {
    required_providers {
        yandex = {
            source = "yandex-cloud/yandex"
            version = "= 0.61.0"
        }
    }
    backend "s3" {
        endpoint = "storage.yandexcloud.net"
        bucket = "m762"
        region = "ru-central1"
        key = "terraform.tfstate"
        skip_region_validation = true
        skip_credentials_validation = true
      
    }
}
