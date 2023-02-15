infrastructure:
	cd terraform; terraform apply; \
	terraform output -raw ansible_inventory > ../ansible/inventory.ini; \
	terraform output -raw db_vault > ../ansible/group_vars/webservers/generated_vault.yml; \
	cd - > /dev/null; \
	ansible-vault encrypt --vault-password-file vault-password ansible/group_vars/webservers/generated_vault.yml

destroy-infrastructure:
	cd terraform; terraform destroy; cd - > /dev/null

encrypt:
	ansible-vault encrypt --vault-password-file vault-password ansible/group_vars/webservers/vault.yml
decrypt:
	ansible-vault decrypt --vault-password-file vault-password ansible/group_vars/webservers/vault.yml


install:
	ansible-galaxy install -r requirements.yml
setup:
	ansible-playbook setup.yml -i inventory.ini --vault-password-file vault-password --tags "setup"
deploy:
	 ansible-playbook playbook.yml -i inventory.ini --vault-password-file vault-password --tags "deploy"