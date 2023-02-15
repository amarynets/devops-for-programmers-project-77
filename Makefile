infrastructure:
	cd terraform; terraform apply; terraform output -raw ansible_inventory > ../ansible/invertory.ini; cd - > /dev/null
destroy-infrastructure:
	cd terraform; terraform destroy; cd - > /dev/null

encrypt:
	ansible-vault encrypt --vault-password-file vault-password ansible/group_vars/all/vault.yml
decrypt:
	ansible-vault decrypt --vault-password-file vault-password ansible/group_vars/all/vault.yml


install:
	ansible-galaxy install -r requirements.yml
setup:
	ansible-playbook setup.yml -i inventory.ini --vault-password-file vault-password --tags "setup"
deploy:
	 ansible-playbook playbook.yml -i inventory.ini --vault-password-file vault-password --tags "deploy"