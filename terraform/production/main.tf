terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

## Networking
resource "hcloud_network" "privNet" {
  name     = "${var.environment}-kumpel-private"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "network-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.privNet.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_firewall" "ssh-access" {
  name = "${var.environment}-ssh-access"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.ssh_access_ips
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "6443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_server" "server" {
  count       = var.master_count
  name        = "${var.environment}-k3s-server-${count.index}"
  image       = "ubuntu-20.04"
  server_type = var.master_server_type
  location    = var.location
  ssh_keys    = var.ssh_keys

  firewall_ids = [hcloud_firewall.ssh-access.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  network {
    network_id = hcloud_network.privNet.id
    ip         = "10.0.1.${count.index + 10}"
  }
}

resource "hcloud_server" "agent" {
  count       = var.worker_count
  name        = "${var.environment}-k3s-agent-${count.index}"
  image       = "ubuntu-20.04"
  server_type = var.worker_server_type
  location    = var.location
  ssh_keys    = var.ssh_keys
  labels      = { worker : "worker" }

  firewall_ids = [hcloud_firewall.ssh-access.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  network {
    network_id = hcloud_network.privNet.id
    ip         = "10.0.1.${count.index + 20}"
  }
}

output "k3s_server_ips" {
  value = hcloud_server.server.*.ipv4_address
}

output "k3s_agent_ips" {
  value = hcloud_server.agent.*.ipv4_address
}

resource "local_file" "ansible_inventory" {
  content = <<EOL
[servers]
%{for i, ip in hcloud_server.server.*.ipv4_address~}
server${i} ansible_host=${ip} ansible_user=root
%{endfor}
[agents]
%{for i, ip in hcloud_server.agent.*.ipv4_address~}
agent${i} ansible_host=${ip} ansible_user=root
%{endfor}
EOL

  filename = "${path.module}/../../ansible/production/inventory.yml"
}
