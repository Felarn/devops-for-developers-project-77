### Hexlet tests and linter status:

[![Actions Status](https://github.com/Felarn/devops-for-programmers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Felarn/devops-for-programmers-project-76/actions)

# Description

This is the second project from Hexlet DevOps course. This project automatically deploys Redmine Docker container on a cluster of virtual machines using Ansible. The Datadog agent is used for monitoring the state of the application servers.

## Requirements:

You should have the following things, that are not covered by this README file:

- 2х VPS with Ubuntu 22.04
- Load balancer
- PostgreSQL database
- host system with:
  - ansible
  - make

## Workspace preparation:

### Get project:

```
git clone git@github.com:AllegroGH/devops-for-programmers-project-76.git
cd devops-for-programmers-project-76
```

### Install dependencies

run these commands on your host system:

```
sudo apt-get install -y ansible python3-pip

pip3 install docker ansible-vault

make install-ansible-requirements
```

### Setup secrets

Create config files from templates using the following command:

```
make copy-templates
```

Fill in files with actual parameters:

- vault-key
- inventory.ini
- group_vars/webservers/vault.yml

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

or

```
make vault-edit
```

## Deploy

```
make deploy
```

### Or step-by-step

```
make setup
make redmine
make datadog
```
