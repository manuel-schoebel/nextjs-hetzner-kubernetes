## New image

export CR_PAT=GITHUB_TOKEN
echo $CR_PAT | docker login ghcr.io -u manuel-schoebel --password-stdin
docker buildx build --no-cache --platform linux/amd64 --push --progress=plain \
 -t "ghcr.io/digitale-kumpel/app-example:0.0.1" \
 -f Dockerfile .

## Deploy

1. update deployment.yaml
2. kubectl apply -f deployement.yaml
