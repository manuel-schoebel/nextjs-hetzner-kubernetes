## Create new database user

Change app name in the create_new_database playbook
Add database password to vault

```bash
cd ansible/
ansible-playbook -i production/inventory.yml playbooks/maintenance/01_create_new_database.yml --extra-vars "env=production"
```

- create new namespace ie `kubectl create namespace skandika-staging`
- Create new app in /apps
- Create domain DNS settings in /terraform/ENV/aws

```bash
cd terraform/production
terraform apply
```

- Create infra like s3 buckets in the project itself via terraform
- Apply secrets from local since they won't be in the github repo

## Shopware

Add pem files as secrets

```
kubectl create secret generic jwt-key-secret \
  --from-file=private.pem=/path/to/your/private.pem \
  --from-file=public.pem=/path/to/your/public.pem \
  -n <namespace>
```

go into pod shell and run

`./bin/console s3:set-visibility`

you might also need to craete a new/initial use via ./bin/console

## K8s Secrets

```
openssl rand -base64 32
echo -n 'super-secret-password' | base64
```
