encrypt:
	ansible-vault encrypt --vault-password-file vault-password ansible/group_vars/all/vault.yml
decrypt:
	ansible-vault decrypt --vault-password-file vault-password ansible/group_vars/all/vault.yml