terraform {
    cloud {
        organization = "amarynets"
        workspaces {
            name = "amarynets"
        }
    }
    
    required_version = ">= 1.1.0"
}