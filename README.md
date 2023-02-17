# The final project of DevOps cource

[![Actions Status](https://github.com/amarynets/devops-for-programmers-project-77/workflows/hexlet-check/badge.svg)](https://github.com/amarynets/devops-for-programmers-project-77/actions)

https://increadeble.tech/


## Release tutorial

### Step 1. Pre-setup

1. Create an account in the DigitalOcean(DO) and get [do_token](https://docs.digitalocean.com/reference/api/create-personal-access-token/)
2. Register in [Terraform Cloud](https://app.terraform.io)(TC)
3. Create a [DataDog](https://app.datadoghq.eu/)(DD) account
4. Generate and store `datadog_api_url, datadog_api_key, datadog_app_key`
5. Add `do_token, datadog_api_url, datadog_api_key, datadog_app_key` into [Terraform Cloud->Variables](https://app.terraform.io/app/amarynets/workspaces/amarynets/variables)
6. Create Terraform Cloud variables for `PROJECT_NAME` and `DOMAIN` with expected values

### Step 2. Setup infrastructure

1. Clone this repo
2. Run `make prepare`. In the input you have to pass the token from Terraform Cloud

### Step 3. Create infrastructure
5. `make infrastructure` will provision all required infrastructure
6. Previous command will create `inventory.ini`(IP addresses for webservers host) and `vault_generated`(A vault with DB credentials)

### Step 4. Setup Ansible

1. Install Ansible. Preferrably version >= core 2.14.1
2. `make install` will install required roles

### Step 5. Setup servers

1. Run `make setup`

### Step 6. Deploy Redmine app

1. `male deploy`

Step 3, 4,5, 6 can be replaced with `make relese`

## Test deployed application

Application will be deployed at `httsp://your-domain`. I've deployed it to [increadeble.tech](https://increadeble.tech).

## Make commands
Terraform
- Setup infrastructure: `make infrastructure`
- Destroy destroy: `make destroy-infrastructure`

Ansible
- Encrypt webservers vault: `make encrypt`
- Decrypt webservers vault: `make decrypt`
- Install roles and collection: `make install`
- Setup webservers: `make setup`
- Deploy Redmine app: `make deploy`

Common
- setup infrastructure and deploy app: `make relese`
