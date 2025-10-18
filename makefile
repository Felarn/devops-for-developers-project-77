tf-init:
	terraform -chdir=./terraform init -backend-config=secrets.backend.tfvars 

tf-apply:
	terraform -chdir=./terraform apply

tf-destroy:
	terraform -chdir=./terraform destroy
	