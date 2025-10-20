install-ansible-requirements:
	ansible-galaxy install -r requirements.yml

copy-templates:
	cp templates/inventory-template.ini inventory.ini
	cp templates/vault-template.yml group_vars/webservers/vault.yml
	cp templates/vault-key vault-key

setup:
	ansible-playbook -i inventory.ini playbook.yml --vault-password-file vault-key --tags setup

redmine:
	ansible-playbook -i inventory.ini playbook.yml --vault-password-file vault-key --tags redmine

datadog:
	ansible-playbook -i inventory.ini playbook.yml --vault-password-file vault-key --tags datadog

deploy:
	ansible-playbook -i inventory.ini playbook.yml --vault-password-file vault-key

vault-edit:
	ansible-vault edit group_vars/webservers/vault.yml --vault-password-file vault-key

vault-encrypt:
	ansible-vault encrypt group_vars/webservers/vault.yml --vault-password-file vault-key

vault-decrypt:
	ansible-vault decrypt group_vars/webservers/vault.yml --vault-password-file vault-key