terraform {
  required_providers {
        random = {
            source = "hashicorp/random"
            version = "3.0.1"
        }
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "2.26.0"
        }
    }
}

provider "digitalocean" {
  token = var.do_token
}