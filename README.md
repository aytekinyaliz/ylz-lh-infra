# YLZ-LH-INFRA

![High-Level Design](./_images/High-Level_Design.png)

## Create an Application Gateway ingress controller and Kubernetes Service in Azure

![infra diagram](./images/High-Level Design.jpg)

#### Prerequisites:

* **Azure subscription:** If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?ref=microsoft.com&utm_source=microsoft.com&utm_medium=docs&utm_campaign=visualstudio) before you begin.

* **Install Terraform:** Follow the directions in the article, [Installing Terraform](https://learn.hashicorp.com/terraform/azure/install_az).
     * Alternately If you'd like to set up you local environment for Azure please follow the steps in the article, [Terraform and configure access to Azure](https://docs.microsoft.com/en-us/azure/terraform/terraform-install-configure)

* **Azure service principal:** change "displayName" and run below command   Take note of the values for the appId, displayName, and password.
[For detail to create an Azure service principal with Azure CLI.](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest)

```
$ az ad sp create-for-rbac --role="Owner" --scopes="/subscriptions/SUBSCRIPTION_ID" --name <displayName>

```

* Obtain the Service Principal Object ID: Run the following command in Cloud Shell:

```
$ az ad sp list --display-name <displayName>

```

### Steps:

* Initialisation of Terraform. There two ways to keep track the terraform states. You need to decide which one to follow.

  * To keep the state locally, run below command.

    ```
    $ terraform init
    ```
  * To keep the state remote storage follow steps under "terrraform-state" folder and run below command. Replace the placeholders with appropriate values which are created when you follow the steps under "terrraform-state" folder  for your environment.

    ```

    $ terraform init -backend-config="storage_account_name=<YourAzureStorageAccountName>" -backend-config="container_name=tfstate" -backend-config="access_key=<YourStorageAccountAccessKey>" -backend-config="key=ylzlh.terraform.tfstate"

    ```

* Change variable in terraform.tfvars with appropriate values for your environment.

* Run the terraform plan command to create the Terraform plan that defines the infrastructure elements.

```

$ terraform plan -out out.plan

```

* Run the terraform apply command to apply the plan to create the Kubernetes cluster.

```
$ terraform apply out.plan

```
### Test the Kubernetes cluster

The Kubernetes tools can be used to verify the newly created cluster.

* Get the Kubernetes configuration from the Terraform state and store it in a file that kubectl can read.
```
$ echo "$(terraform output kube_config)" > ~/.azurek8s

```
* Set an environment variable so that kubectl picks up the correct config.

```
$ export KUBECONFIG=~/.azurek8s
```

* Verify the health of the cluster.

```
$ kubectl get nodes
```

### Install Azure AD Pod Identity

* If RBAC is disabled, run the following command to install Azure AD Pod Identity to your cluster:

```
$ kubectl create -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/deployment.yaml

```


### Install Helm

The code in this section uses Helm - Kubernetes package manager - to install the application-gateway-kubernetes-ingress package:

* If RBAC is disabled, run the following command to install and configure Helm:

```
$ helm init

```

* Add the AGIC Helm repository:

```
helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
helm repo update

```

### Install Ingress Controller Helm Chart

Edit the helm/helm-config.yaml and enter appropriate values for appgw and armAuth sections.

* The values are described as follows:

  * verbosityLevel: Sets the verbosity level of the AGIC logging infrastructure. See Logging Levels for possible values.
  * appgw.subscriptionId: The Azure Subscription ID for the App Gateway. Example: a123b234-a3b4-557d-b2df-a0bc12de1234
  * appgw.resourceGroup: Name of the Azure Resource Group in which App Gateway was created.
  * appgw.name: Name of the Application Gateway. Example: applicationgateway1.
  * appgw.shared: This boolean flag should be defaulted to false. Set to true should you need a Shared App Gateway.
  * kubernetes.watchNamespace: Specify the name space, which AGIC should watch. The namespace can be a single string value, or a comma-separated list of namespaces. Leaving this variable commented out, or setting it to blank or empty string results in Ingress Controller observing all accessible namespaces.
  * armAuth.type: A value of either aadPodIdentity or servicePrincipal.
  * armAuth.identityResourceID: Resource ID of the managed identity.
  * armAuth.identityClientId: The Client ID of the Identity.
  * armAuth.secretJSON: Only needed when Service Principal Secret type is chosen (when armAuth.type has been set to servicePrincipal).

* Key notes:

  * The identityResourceID value is created in the terraform script and can be found by running: echo "$(terraform output identity_resource_id)".
  * The identityClientID value is created in the terraform script and can be found by running: echo "$(terraform output identity_client_id)".
  * The <resource-group> value is the resource group of your App Gateway.
  * The <identity-name> value is the name of the created identity.
  * All identities for a given subscription can be listed using: az identity list.


* Install the Application Gateway ingress controller package:
```
helm install -f helm-config.yaml application-gateway-kubernetes-ingress/ingress-azure


```

Note: This application emerge from the article [Tutorial: Create an Application Gateway ingress controller in Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/terraform/terraform-create-k8s-cluster-with-aks-applicationgateway-ingress)
