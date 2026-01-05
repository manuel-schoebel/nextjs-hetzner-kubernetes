#!/bin/bash

# File where the Terraform variables are stored
TFVARS_FILE="terraform/variables.tf"

# Get current IPv6 address
CURRENT_IPV6=$(curl -6 -s https://ifconfig.co)

# If you have an IPv4 address to include, you can hardcode or fetch it similarly
STATIC_IPV4=""

# Prepare the new list of IP addresses
NEW_SSH_ACCESS_IPS="[\"$STATIC_IPV4\", \"$CURRENT_IPV6\"]"

# Update the terraform.tfvars file with the new IPs
sed -i '' "s/^ssh_access_ips = .*/ssh_access_ips = $NEW_SSH_ACCESS_IPS/" $TFVARS_FILE

echo "Updated ssh_access_ips in $TFVARS_FILE:"
cat $TFVARS_FILE | grep ssh_access_ips