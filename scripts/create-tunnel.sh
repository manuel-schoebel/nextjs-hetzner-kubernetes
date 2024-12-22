#!/bin/bash

# Check if the environment argument is passed
if [ -z "$1" ]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

# Environment argument
ENVIRONMENT=$1

# Inventory file path
INVENTORY_FILE="ansible/$ENVIRONMENT/inventory.yml"

# Extract server0 IP address from the Ansible inventory
SERVER_IP=$(ansible-inventory -i "$INVENTORY_FILE" --host server0 | jq -r .ansible_host)

# Check if jq and ansible-inventory command succeeded
if [ -z "$SERVER_IP" ]; then
  echo "Failed to retrieve server0 IP address from the inventory."
  exit 1
fi

# Create the SSH tunnel
echo "Creating SSH tunnel to server0 (IP: $SERVER_IP)..."
ssh -L 6443:localhost:6443 root@"$SERVER_IP"