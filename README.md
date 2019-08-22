# Alibaba Cloud DNS ACME webhook

This project is based on code initialy commited in https://github.com/go-acme/lego

## Tests

```
scripts/fetch-test-binaries.sh
TEST_ZONE_NAME=example.com. go test .
```

## Deploy

Build and publish the docker image:
```
docker build . -t <your registry>/alidns-webhook:latest
docker push <your registry>/alidns-webhook
```

Use the helm chart in deploy directory.
```
helm template deploy --set image.repository=<your registry> --set image.tag=latest
```

Create the secret holding alibaba credential :
```
kubectl create secret generic alidns-secrets --from-literal="access-token=yourtoken" --from-literal="secret-key=yoursecretkey"
```
