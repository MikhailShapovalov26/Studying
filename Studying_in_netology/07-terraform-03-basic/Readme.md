## 7.3
Создание бакет s3 сделал ручками. В самом облаке. Обходными путями не смог.
Так же сделал БД dynamodb с помощью отдельного терраформ файла. 

    terraform {
    required_version = "= 1.1.8"

    required_providers {
        yandex = {
        source  = "yandex-cloud/yandex"
        version = ">= 0.73"
        }
    }
    }

    provider "yandex" {
    zone="ru-central1-a"
    }
    resource "yandex_ydb_database_serverless" "database1" {
    name      = "test-ydb-serverless"
    }
2)
terraform workspace new prod 
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
 mikhail@HP  ~/terraform/new_1  terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
terraform workspace list
  default
  prod
* stage
  все методы решения прописаны в файле [./resource.tf](resource.tf)

Там я создал блок

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
И далее вместо параметров указывал переменные из блокал local

    terraform plan

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
      + create

    Terraform will perform the following actions:

      # yandex_compute_instance.vm-762[0] will be created
      + resource "yandex_compute_instance" "vm-762" {
          + created_at                = (known after apply)
          + folder_id                 = (known after apply)
          + fqdn                      = (known after apply)
          + hostname                  = (known after apply)
          + id                        = (known after apply)
          + metadata                  = {
              + "foo"     = "bar"
              + "ssh-key" = "~/.ssh/rsa.pub"
            }
          + name                      = "vm-762(stage)"
          + network_acceleration_type = "standard"
          + platform_id               = "standard-v1"
          + service_account_id        = (known after apply)
          + status                    = (known after apply)
          + zone                      = "ru-central1-b"

          + boot_disk {
              + auto_delete = true
              + device_name = (known after apply)
              + disk_id     = (known after apply)
              + mode        = (known after apply)

              + initialize_params {
                  + description = (known after apply)
                  + image_id    = "image_id"
                  + name        = (known after apply)
                  + size        = (known after apply)
                  + snapshot_id = (known after apply)
                  + type        = "network-hdd"
                }
            }

          + network_interface {
              + index              = (known after apply)
              + ip_address         = (known after apply)
              + ipv4               = true
              + ipv6               = (known after apply)
              + ipv6_address       = (known after apply)
              + mac_address        = (known after apply)
              + nat                = (known after apply)
              + nat_ip_address     = (known after apply)
              + nat_ip_version     = (known after apply)
              + security_group_ids = (known after apply)
              + subnet_id          = "enppknviiq7ntqrml4e8"
            }

          + placement_policy {
              + placement_group_id = (known after apply)
            }

          + resources {
              + core_fraction = 100
              + cores         = 1
              + memory        = 4
            }

          + scheduling_policy {
              + preemptible = (known after apply)
            }
        }

      # yandex_compute_instance.vm-for-each["prod"] will be created
      + resource "yandex_compute_instance" "vm-for-each" {
          + created_at                = (known after apply)
          + folder_id                 = (known after apply)
          + fqdn                      = (known after apply)
          + hostname                  = (known after apply)
          + id                        = (known after apply)
          + metadata                  = {
              + "foo"     = "bar"
              + "ssh-key" = "~/.ssh/rsa.pub"
            }
          + name                      = "vm-762(stage)"
          + network_acceleration_type = "standard"
          + platform_id               = "standard-v1"
          + service_account_id        = (known after apply)
          + status                    = (known after apply)
          + zone                      = "ru-central1-b"

          + boot_disk {
              + auto_delete = true
              + device_name = (known after apply)
              + disk_id     = (known after apply)
              + mode        = (known after apply)

              + initialize_params {
                  + description = (known after apply)
                  + image_id    = "inage_id"
                  + name        = (known after apply)
                  + size        = (known after apply)
                  + snapshot_id = (known after apply)
                  + type        = "network-hdd"
                }
            }

          + network_interface {
              + index              = (known after apply)
              + ip_address         = (known after apply)
              + ipv4               = true
              + ipv6               = (known after apply)
              + ipv6_address       = (known after apply)
              + mac_address        = (known after apply)
              + nat                = (known after apply)
              + nat_ip_address     = (known after apply)
              + nat_ip_version     = (known after apply)
              + security_group_ids = (known after apply)
              + subnet_id          = "enppknviiq7ntqrml4e8"
            }

          + placement_policy {
              + placement_group_id = (known after apply)
            }

          + resources {
              + core_fraction = 100
              + cores         = 1
              + memory        = 4
            }

          + scheduling_policy {
              + preemptible = (known after apply)
            }
        }

    Plan: 2 to add, 0 to change, 0 to destroy.
