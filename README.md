# Alibaba Cloud DNS ACME webhook

This project is based on code initialy commited in https://github.com/go-acme/lego

This is an webhook implementation for Cert-Manager to use with Alibaba Cloud DNS (aka AliDNS).
See the cert-manager's documentation for more details on webhook : https://cert-manager.io/docs/concepts/webhook/


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

## Create an issuer

The name of solver to use is `alidns-solver`. You can create an issuer as below :
```
apiVersion: v1
items:
- apiVersion: cert-manager.io/v1alpha2
  kind: Issuer
  metadata:
    name: letsencrypt
    namespace: default
  spec:
    acme:
      email: contact@example.com
      privateKeySecretRef:
        name: letsencrypt
      server: https://acme-v02-staging.api.letsencrypt.org/directory
      solvers:
      - dns01:
          webhook:
            config:
              accessTokenSecretRef:
                key: access-token
                name: alidns-secrets
              regionId: cn-beijing
              secretKeySecretRef:
                key: secret-key
                name: alidns-secrets
            groupName: example.com
            solverName: alidns-solver
        selector:
          dnsNames:
          - '*.example.com'

```
See cert-manager documenation for more information : https://cert-manager.io/docs/configuration/acme/dns01/

## Create the certification

Then create the certificate which will use this issuer : https://cert-manager.io/docs/usage/certificate/
