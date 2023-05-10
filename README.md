# The final project of DevOps cource

<!---[![Actions Status](https://github.com/amarynets/devops-for-programmers-project-77/workflows/hexlet-check/badge.svg)](https://github.com/amarynets/devops-for-programmers-project-77/actions)-->

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
5. `make setup` will provision all required infrastructure and software on servers
6. Previous command will create `inventory.ini`(IP addresses for webservers host) and `vault_generated`(A vault with DB credentials)

### Step 4. Deploy Redmine app

1. `make deploy`

Step 2, 3, 4 can be replaced with `make all`

## Test deployed application

Application will be deployed at `increadeble.tech`. I've deployed it to [increadeble.tech](https://increadeble.tech).

## Make commands
Terraform
- Setup infrastructure: `make setup`
- Destroy destroy: `make destroy`

Ansible
- Encrypt webservers vault: `make encrypt`
- Decrypt webservers vault: `make decrypt`
- Clean up inventory and vault files: `make clean-up-workdir`
- Install roles and collection: `make prepare`
- Setup webservers: `make setup`
- Deploy Redmine app: `make deploy`

Common
- setup infrastructure and deploy app: `make all`
