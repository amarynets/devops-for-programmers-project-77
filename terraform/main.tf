## Terraform configuration


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
  count              = 2
  image              = "ubuntu-22-10-x64"
  name               = "web-${count.index}"
  region             = "fra1"
  size               = "s-1vcpu-1gb"
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

resource "digitalocean_record" "record" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_loadbalancer.loadbalancer.ip
}

resource "digitalocean_domain" "domain" {
  name = "increadeble.tech"
}

resource "digitalocean_certificate" "certificate" {
  name    = "certificate"
  type    = "lets_encrypt"
  domains = [digitalocean_domain.domain.name]
}

resource "digitalocean_loadbalancer" "loadbalancer" {
  name   = "loadbalancer"
  region = "fra1"

  forwarding_rule {
    entry_protocol  = "http"
    entry_port      = 80
    target_protocol = "http"
    target_port     = 8000
  }

  forwarding_rule {
    entry_protocol   = "https"
    entry_port       = 443
    target_protocol  = "http"
    target_port      = 8000
    certificate_name = digitalocean_certificate.certificate.name
  }

  healthcheck {
    port     = 8000
    protocol = "http"
    path     = "/"
  }

  sticky_sessions {
    type = "cookies"
    cookie_name = "DOBCOOKIE"
    cookie_ttl_seconds = 3600
  }
  redirect_http_to_https = true

  droplet_ids = digitalocean_droplet.web.*.id
}