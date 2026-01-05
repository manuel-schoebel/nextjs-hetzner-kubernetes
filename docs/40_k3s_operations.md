### Connect via Lens app

Make sure that the Cluster exists. If not create new one and copy the cluster config over. Rename default from the config to something else.

Make sure ssh tunnel to server0 is up

```
./scripts/create-tunnel.sh production
```

### Use kubectl locally

```bash
# From project root
export KUBECONFIG=$(pwd)/.kube/k3s.yml
kubectl get nodes
```

### Scale down

kubectl scale statefulset galera-mariadb-galera --replicas=0

### Portforwarding with kubectl to access internal service

kubectl port-forward service/haproxy-service 8080:8080

### Use ArgoCD

kubectl port-forward svc/argocd-server -n argocd 8080:443

### Log into container

```
kubectl exec -it POD -- bash
```

### pull newest image and restart

```
kubectl rollout restart deployment app-example-deployment -n app-example
# verify rollout
kubectl rollout status deployment app-example-deployment -n app-example
```

### Show logs

```
kubectl logs app-example-deployment-cd6bc885f-rw6j7 -n app-example

# of specific e.g. init container
kubectl logs -f krautkugel-shopware-web-5bbcd59c4d-lbqs5 -n krautkugel -c init
```

### See pod status

```
kubectl describe pod app-example-deployment-5f74cf5dcf-46bjp -n app-example
```

### After deployment was updated

```
kubectl apply -f deploy.yaml
# verify rollout
kubectl rollout status deployment app-example-deployment -n app-example
```

### Show services

Here you can also see the ports and ips

```
kubectl get svc -n proxysql
```

### Check cert issuing

There is the Certificate ressource

```
kubectl get certificates --all-namespaces
kubectl describe certificate app-example
kubectl get clusterissuer
kubectl logs -l app=cert-manager -n cert-manager
kubectl get challenges
kubectl get orders
kubectl describe order proxysql-staging-1-1422828513
kubectl get certificaterequest
```

Clear stale ressources

```
kubectl delete certificaterequest app-example-1 -n app-example
kubectl delete order app-example-1-1419748978 -n app-example
kubectl delete challenge app-example-1-1419748978-957704095 -n app-example
kubectl delete certificate app-example -n app-example
```
