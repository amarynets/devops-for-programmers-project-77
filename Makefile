infrastructure:
	cd terraform; terraform apply; \
	terraform output -raw ansible_inventory > ../ansible/inventory.ini; \
	terraform output -raw db_vault > ../ansible/group_vars/webservers/vault_generated.yml; \
	cd - > /dev/null; \
	ansible-vault encrypt --vault-password-file vault-password ansible/group_vars/webservers/vault_generated.yml

destroy-infrastructure:
	cd terraform; terraform destroy; cd - > /dev/null

encrypt:
	ansible-vault encrypt --vault-password-file vault-password ansible/group_vars/webservers/vault.yml
decrypt:
	ansible-vault decrypt --vault-password-file vault-password ansible/group_vars/webservers/vault.yml

install:
	cd ansible; ansible-galaxy install -r requirements.yml; cd - > /dev/null
setup:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --vault-password-file vault-password --tags "setup"
deploy:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --vault-password-file vault-password --tags "deploy"

relese: infrastructure install setup deploy