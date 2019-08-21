module github.com/olivierboudet/cert-manager-alidns-webhook

go 1.12

require (
	github.com/aliyun/alibaba-cloud-sdk-go v0.0.0-20190708091929-88eb281ef085
	github.com/dgrijalva/jwt-go v3.2.0+incompatible // indirect
	github.com/imdario/mergo v0.3.7 // indirect
	github.com/jetstack/cert-manager v0.8.1
	github.com/pkg/errors v0.8.0
	k8s.io/apiextensions-apiserver v0.0.0-20190413053546-d0acb7a76918
	k8s.io/apimachinery v0.0.0-20190413052414-40a3f73b0fa2
	k8s.io/client-go v11.0.0+incompatible
)

replace k8s.io/client-go => k8s.io/client-go v0.0.0-20190413052642-108c485f896e

replace github.com/evanphx/json-patch => github.com/evanphx/json-patch v0.0.0-20190203023257-5858425f7550
