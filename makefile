tf-init:
	terraform -chdir=./terraform init -backend-config=secrets.backend.tfvars 

tf-apply:
	terraform -chdir=./terraform apply

tf-destroy:
	terraform -chdir=./terraform destroy

secrets:
	cp ./terraform/secrets-auto-template.tfvars ./terraform/secrets.auto.tfvars
	cp ./terraform/secrets-backend-template.tfvars ./terraform/secrets.backend.tfvars