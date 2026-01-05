ssh into ipv6

```
ssh root@2a01:4f8:1c1b:969d::1
```

https://devopscube.com/kubernetes-tutorials-beginners/

```
kubectl get po -n kube-system
```

```
kubectl delete -f <filename>
```

```
kubeadm join 10.0.0.3:6443 --token q1bek9.zp30dsfpiiy61zce \
	--discovery-token-ca-cert-hash sha256:30db6f5ee79ef042e1fdc5bbb6f1b96dfcea3d935bc9b87b8cf507024838a836
```

## Create secret keys

```bash
openssl rand -base64 32
```

## Links

K3s Setup
https://ellie.wtf/notes/hetzner-k3s
https://community.hetzner.com/tutorials/k3s-glusterfs-loadbalancer
https://docs.k3s.io/

https://harshwardhanpj.medium.com/ha-k3s-cluster-with-external-database-cluster-on-separate-instance-c6947c9c502c

Proxysql
https://www.percona.com/blog/getting-started-with-proxysql-in-kubernetes/

## Open Questions

### How can i resize the volume claim for the galera maria dbs?
