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
            version = "2.26.0"
        }
    }
    required_version = ">= 1.1.0"
}