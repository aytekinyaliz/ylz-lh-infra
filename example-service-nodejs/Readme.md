### Deployment of an example service

* Login to Azure Container Registry
```
az acr login -n acrexampleproject

```

* Build docker image

```
docker build -t acrexampleproject.azurecr.io/example-service:1 .

```
* Push docker image

```
docker push acrexampleproject.azurecr.io/example-service:1
```

* Apply the YAML file:

```
kubectl apply -f kube-manifests -R
```
