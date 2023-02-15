## Terraform configuration
terraform {
    cloud {
        organization = "amarynets"
        workspaces {
            name = "amarynets"
        }
    }
    required_providers {
        random = {
            source = "hashicorp/random"
            version = "3.0.1"
        }
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "1.22.2"
        }
    }
    required_version = ">= 1.1.0"
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "mysshkey" {
  name = "mykey"
}

output "webservers" {
  value = digitalocean_droplet.web
}

resource "digitalocean_droplet" "web" {
  count              = 1
  image              = "ubuntu-22-10-x64"
  name               = "web-${count.index + 1}"
  region             = "fra1"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.mysshkey.id
  ]
}

output "ansible_inventory" {
  value = templatefile(
        "${path.module}/inventory.tmpl",
        {
            webservers = digitalocean_droplet.web
        }
    )
}

resource "digitalocean_database_db" "db" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "redminedb"
}

resource "digitalocean_database_cluster" "postgres" {
  name       = "postgres-cluster"
  engine     = "pg"
  version    = "15"
  size       = "db-s-1vcpu-1gb"
  region     = "fra1"
  node_count = 1
}

output "db-host" {
  value = {
    host = digitalocean_database_cluster.postgres.private_host,
    port = digitalocean_database_cluster.postgres.port,
    user = digitalocean_database_cluster.postgres.user,
    
  }
}

output "db-password" {
  value = digitalocean_database_cluster.postgres.password
  sensitive = true
}

output "db" {
  value = digitalocean_database_db.db.name
}

output "db_vault" {
  value = templatefile(
        "${path.module}/generated_vault.tmpl",
        {
            host = digitalocean_database_cluster.postgres.private_host,
            port = digitalocean_database_cluster.postgres.port,
            user = digitalocean_database_cluster.postgres.user,
            password = nonsensitive(digitalocean_database_cluster.postgres.password),
            database =  digitalocean_database_db.db.name
        }
    )
}
