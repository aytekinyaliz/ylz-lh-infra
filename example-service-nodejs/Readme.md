### Deployment of an example service

* Login to Azure Container Registry
```
az acr login -n acrylzlh

```

* Build docker image

```
docker build -t acrylzlh.azurecr.io/example-service:1 .

```
* Push docker image

```
docker push acrylzlh.azurecr.io/example-service:1
```

* Apply the YAML file:

```
kubectl apply -f kube-manifests -R
```

* Test to service

```
http://<ProjectName>.<Location>.cloudapp.azure.com/nodejs

http://ylz-lh.westeurope.cloudapp.azure.com/nodejs

```
