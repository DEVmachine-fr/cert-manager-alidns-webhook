# Alibaba Cloud DNS ACME webhook

This project is based on code initialy commited in https://github.com/go-acme/lego

This is an webhook implementation for Cert-Manager to use with Alibaba Cloud DNS (aka AliDNS).
See the cert-manager's documentation for more details on webhook : https://cert-manager.io/docs/concepts/webhook/

## Usage
### Installation

```
helm repo add cert-manager-alidns-webhook https://devmachine-fr.github.io/cert-manager-alidns-webhook
helm repo update
helm install alidns-webhook cert-manager-alidns-webhook/alidns-webhook
```

Create the secret holding alibaba credential :
```
kubectl create secret generic alidns-secrets --from-literal="access-token=yourtoken" --from-literal="secret-key=yoursecretkey"
```

### Create an issuer

The name of solver to use is `alidns-solver`. You can create an issuer as below :
```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt
  namespace: default
spec:
  acme:
    email: contact@example.com
    privateKeySecretRef:
      name: letsencrypt
    server: https://acme-staging-v02.api.letsencrypt.org/directory
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
        - example.com
        - '*.example.com'
```

Or you can create an ClusterIssuer as below :
```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    email: contact@example.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt
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
            groupName: example.com # groupName must match the one configured on webhook deployment (see Helm chart's values) !
            solverName: alidns-solver
```

See cert-manager documentation for more information : https://cert-manager.io/docs/configuration/acme/dns01/

### Create the certification

Then create the certificate which will use this issuer : https://cert-manager.io/docs/usage/certificate/


Create an certification using Issuer as below :
```
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-tls
spec:
  secretName: example-com-tls
  commonName: example.com
  dnsNames:
  - example.com
  - "*.example.com"
  issuerRef:
    name: letsencrypt
    kind: Issuer
```

Or create an certification using ClusterIssuer as below :
```
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-tls
spec:
  secretName: example-com-tls
  commonName: example.com
  dnsNames:
  - example.com
  - "*.example.com"
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer
```



## Tests

Modify testdata/alidns-solver to add a valid token for alidns. 

```
TEST_ZONE_NAME=example.com. make test # replace example.com with a zone which belongs to given credentials
```

## Build

Build and publish the docker image:
```
docker build . -t <your registry>/alidns-webhook:latest
docker push <your registry>/alidns-webhook
```

Use the helm chart in charts directory.
```
helm template charts --set image.repository=<your registry> --set image.tag=latest
```
