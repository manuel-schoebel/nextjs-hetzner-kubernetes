OLD: use ansible playbooks

# Server Setup (master)

1. install
2. init cluster
3. get access from local
4. install hccm via helm (install helm)

Note: Not using traefik because we want to later set it up so the hccm manages the hetzner load balancer

First server

```
curl -sfL https://get.k3s.io | sh -s - server \
	--cluster-init \
    --disable-cloud-controller \
    --disable local-storage \
    --node-name="$(hostname -f)" \
    --flannel-iface=enp7s0 \
    --kubelet-arg="cloud-provider=external" \
    --secrets-encryption \
    --disable=traefik \
    --token=CHANGE ME
```

Subsequent servers

```
curl -sfL https://get.k3s.io | sh -s - server \
	--server SERVER ADDRESS \
    --disable-cloud-controller \
    --disable local-storage \
    --node-name="$(hostname -f)" \
    --flannel-iface=enp7s0 \
    --kubelet-arg="cloud-provider=external" \
    --secrets-encryption \
    --disable=traefik \
    --token=CHANGE ME
```

# Agent Setup (workers)

```
curl -sfL https://get.k3s.io | sh -s - agent \
	--server SERVER ADDRESS \
	--node-name="$(hostname -f)" \
	--flannel-iface=enp7s0 \
	--kubelet-arg="cloud-provider=external" \
	--token=CHANGE ME
```

## Get local access

Config from

```
cat /etc/rancher/k3s/k3s.yaml
```

Tunnel
ssh -L 6443:localhost:6443 root@a server ip

## TLS

Using cloudflare as a proxy that handles tls termination you have to set it to "FULL" encryption mode under

Domain > SSL/TLS > Overview > Confiture

## Cert Manager
