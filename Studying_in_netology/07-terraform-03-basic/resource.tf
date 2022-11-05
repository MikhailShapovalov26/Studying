locals {
  web_instance_type_map = {
    stage = "standard-v1"
    prod  = "gpu-standard-v1"
  }

  web_count_map = {
    stage = 1
    prod  = 2
  }
  web_zone_map = {
    stage = "ru-central1-b"
    prod = "ru-central1-a"
  }
  web_memory_map = {
    stage = 4
    prod = 1
  }
  web_name_map = {
    stage = "vm-762(stage)"
    prod = "vm-762(prod)"
  }
}

resource "yandex_compute_instance" "vm-762" {
    platform_id = local.web_instance_type_map[terraform.workspace]
    count = local.web_count_map[terraform.workspace]
    name = local.web_name_map[terraform.workspace]
    zone = local.web_zone_map[terraform.workspace]
    resources {
        cores = 1
        memory = local.web_memory_map[terraform.workspace]
    }
    boot_disk {
        initialize_params {
            image_id = "image_id"
        }
    }
    network_interface  {
        subnet_id = "enppknviiq7ntqrml4e8"
    }
    metadata = {
        foo = "bar"
        ssh-key = "~/.ssh/rsa.pub"
    }
}
resource "yandex_compute_instance" "vm-for-each" {
    platform_id = local.web_instance_type_map[terraform.workspace]
    for_each = local.web_count_map
    name = local.web_name_map[terraform.workspace]
    zone = local.web_zone_map[terraform.workspace]
    resources {
        cores = 1
        memory = local.web_memory_map[terraform.workspace]
    }
    boot_disk {
        initialize_params {
            image_id = "inage_id"
        }
    }
    network_interface  {
        subnet_id = "enppknviiq7ntqrml4e8"
    }
    metadata = {
        foo = "bar"
        ssh-key = "~/.ssh/rsa.pub"
    }

  
}