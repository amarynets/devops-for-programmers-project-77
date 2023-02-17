prepare:
	cd terraform; terraform login; terraform init
	
infrastructure:
	echo $RANDOM | base64 | head -c 20 > vault-password; \
	rm -rf ansible/group_vars/webservers/vault_generated.yml; \
	cd terraform; terraform apply; \
	terraform output -raw ansible_inventory > ../ansible/inventory.ini; \
	terraform output -raw vault > ../ansible/group_vars/webservers/vault_generated.yml; \
	cd ../; \
	ansible-vault encrypt --vault-password-file vault-password ansible/group_vars/webservers/vault_generated.yml

destroy-infrastructure:
	cd terraform; terraform destroy;

encrypt:
	ansible-vault encrypt --vault-password-file vault-password ansible/group_vars/webservers/vault_generated.yml
decrypt:
	ansible-vault decrypt --vault-password-file vault-password ansible/group_vars/webservers/vault_generated.yml

install:
	cd ansible; ansible-galaxy install -r requirements.yml
setup:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --vault-password-file vault-password --tags "setup"
deploy:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --vault-password-file vault-password --tags "deploy"

relese: infrastructure install setup deploy

.PHONY: random_pwd encrypt decrypt