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
