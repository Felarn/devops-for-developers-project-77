### Hexlet tests and linter status:

[![Actions Status](https://github.com/Felarn/devops-for-developers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Felarn/devops-for-developers-project-77/actions)

# requirements

- host machine with:

  - terraform
  - ansible
  - make
  - ssh file

- account on Yandex Cloud:

  - OAuth token

- S3 storage and connection info:
  - bucket
  - access_key
  - secret_key
  - dynamodb_endpoint
  - dynamodb_table

# Start

### clone ther repo

```
git clone git@github.com:Felarn/devops-for-developers-project-77.git
cd devops-for-developers-project-77
```

### create "secrets" files from templates

```
make secrets
```

Fill in variables located in following fles with actual information:

- `terraform/secrets.auto.tfvars`
- `secrets.backend.tfvars`

### Initialize Terraform project

```
make tf-init
```

# Prepare infrastracture

```
make tf-apply
```

### in case you need to remove infrastracture use:

```
make tf-apply
```

# Project deployment

## Workspace preparation:

### Install dependencies

run these commands on your host system to install required software:

```
sudo apt-get install -y ansible python3-pip

pip3 install docker ansible-vault

make ans-install-requirements
```

### Setup secrets

Create config files from templates using the following command:

```
make ans-copy-templates
```

Fill in files with actual parameters:

- ./ansible/vault-key
- ./ansible/inventory.ini
- ./ansible/group_vars/webservers/vault.yml

Encrypt the vault file

```
make vault-encrypt
```

If you need to change settings in group_vars/webservers/vault.yml file after encryption use these commands:

```
make vault-decrypt
# make changes
make vault-encrypt
```

## Deploy project

```
make ans-deploy
```
