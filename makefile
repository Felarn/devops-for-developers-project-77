tf-init:
	terraform -chdir=./terraform init -backend-config=secrets.backend.tfvars 

tf-apply:
	terraform -chdir=./terraform apply

tf-destroy:
	terraform -chdir=./terraform destroy

secrets:
	cp ./terraform/secrets-auto-template.tfvars ./terraform/secrets.auto.tfvars
	cp ./terraform/secrets-backend-template.tfvars ./terraform/secrets.backend.tfvars

ans-install-requirements:
	$(MAKE) -C ./ansible install-ansible-requirements

ans-copy-templates:
	$(MAKE) -C ./ansible copy-templates

ans-deploy:
	$(MAKE) -C ./ansible deploy

vault-encrypt:
	$(MAKE) -C ./ansible vault-encrypt

vault-decrypt:
	$(MAKE) -C ./ansible vault-decrypt