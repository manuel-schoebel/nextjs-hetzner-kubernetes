Use Terraform to setup the infrastructure

```
aws-vault!!! terraform apply -var-file="terraform.tfvars.staging" -state="terraform.tfstate.staging"
```

# IP Ranges

k3s server
10.0.1.10
10.0.1.11
10.0.1.12

k3s agents
10.0.1.20
10.0.1.21
10.0.1.22
...

```
cd terraform

# Staging
terraform apply -var-file="terraform.tfvars.staging" -state="terraform.tfstate.staging"

# Production
cd terraform/production
terraform apply
```
