# Alibaba Cloud DNS ACME webhook

This project is based on code initialy commited in https://github.com/go-acme/lego

## Tests

```
scripts/fetch-test-binaries.sh
TEST_ZONE_NAME=example.com. go test .
```

## Deploy

Use the helm chart in deploy directory.
Create the secret holding alibaba credential :
```
kubectl create secret generic alidns-secrets --from-literal="access-token=yourtoken" --from-literal="secret-key=yoursecretkey"
```
