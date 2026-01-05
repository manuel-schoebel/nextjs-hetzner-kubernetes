## Notes

- create config file used on startup
- Deployment that runs 3 images of proxysql
- They need to be aware of each other (what are their addresses?)
- Need user in the galera cluster
- Specify the galera nodes

## Connect to proxysql admin

```
kubectl get pods -n proxysql -l app=proxysql
kubectl exec -it proxysql-0 -n proxysql -- /bin/bash
```
