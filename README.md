## Create an Application Gateway ingress controller and Kubernetes Service in Azure

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

    $ terraform init -backend-config="storage_account_name=<YourAzureStorageAccountName>" -backend-config="container_name=tfstate" -backend-config="access_key=<YourStorageAccountAccessKey>" -backend-config="key=exampleproject.terraform.tfstate"

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
