
## Set up Azure storage to store Terraform state

Terraform tracks state locally via the terraform.tfstate file. This pattern works well in a single-person environment. In a multi-person environment, Azure storage is used to track state

In order to create storage for state follow below steps.

#### Prerequisites:

* **Azure subscription:** If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?ref=microsoft.com&utm_source=microsoft.com&utm_medium=docs&utm_campaign=visualstudio) before you begin.

* **Install Terraform:** Follow the directions in the article, [Installing Terraform](https://learn.hashicorp.com/terraform/azure/install_az).
     * Alternately If you'd like to set up you local environment for Azure please follow the steps in the article, [Terraform and configure access to Azure](https://docs.microsoft.com/en-us/azure/terraform/terraform-install-configure)

* **Azure service principal:** Change "displayName" and run below command and  take note of the values for the appId, displayName, and password.
[For detail to create an Azure service principal with Azure CLI.](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest)

```
$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID" --name <displayName>

```

* Obtain the Service Principal Object ID: Run the following command in Cloud Shell:

```
$ az ad sp list --display-name <displayName>

```

### Steps

1. Change variable in terraform.tfvars with appropriate values for your environment.

3. Run the terraform plan command to create the Terraform plan that defines the infrastructure elements.

```
$ terraform plan -out out.plan -var-file=../terraform.tfvars
```

4. Run the terraform apply command to apply the plan to create resource group, storage account and storage container.
```
$ terraform apply out.plan -var-file=../terraform.tfvars
```

5. please note Your Azure Storage Account Name and Storage Account Access Key to use it a repo that you want to init with remote state

Not:
"HashiCorp no plan to support arbitrary expressions in the backend block because it is technically impossible: the backend stores the state and the state is needed to evaluate expressions, so something has to be statically configured in order to give Terraform a starting point to fetch the data it needs for the rest of the work. For [detail](https://github.com/hashicorp/terraform/issues/22088#issuecomment-521056027)
