## 1. Push new image

```
cd app-example
# ghcr

export CR_PAT=GITHUB_TOKEN
echo $CR_PAT | docker login ghcr.io -u manuel-schoebel --password-stdin
docker buildx build --platform linux/amd64 --no-cache --push --progress=plain \
 -t "ghcr.io/digitale-kumpel/sample:k8s-test-v0.0.2" \
 -f Dockerfile .
```

## 2. Setup domain in terraform

## 3. Create kubernetes config files

In the project create a kubernetes folder

You need at least deploy.yaml and service.yaml

```
# setup kubectl local before
kubectl apply -f app-example/kubernetes
```

## Configure Argo

in apps/ create new app/production|staging folder and an application.yml

```

# Apply secrets first since they are not commited and argo will not be able to use them
kubectl apply -f PATH/TO/secrets.yml

# or staging
export KUBECONFIG=/Users/manuelschoebel/Workspace/digitale-kumpel/kumpel.cloud/.kube/config-production.yml

kubectl apply -f apps/kinvivo/production/strapi.yml
```
