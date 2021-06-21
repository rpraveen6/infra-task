#!/bin/bash


#ResourceGroup Details
RGName="terra_RG"
Location="westus"

clear
echo "Enter the Azure SP details to continue"
echo -e "\nEnter the Service Principal App ID: \c"
read -s "ServicePrincipalAppId"
echo -e "\nEnter the Service Principal Password:\c "
read -s "password"
echo -e "\nEnter the Tenant ID: \c"
read -s "tenantId"


echo -e "\nLogin using the created SP Account for further steps"
az login --service-principal --username "${ServicePrincipalAppId}" --password "${password}" --tenant "${tenantId}"
[[ $? -ne 0 ]] && echo -e "\n--Login failure" || echo -e "\n++Login Success"

#subscription_details
subscriptionId=$(az account show --query id -o tsv)

##Create a respective resource group
echo "creating a resource group"
az group create --name "${RGName}" --location "${Location}"
[[ $? -ne 0 ]] && echo -e "\n--RG ${RGName} Creation Failure" || echo -e "\n++RG ${RGName} Creation Success"

sleep 5


SAName="terraforminfrasa"
ConName_TF="demoappterrastate"

##create a storage account
echo "Creating the storage Account"
az storage account create -g "${RGName}" -l "${Location}" \
          --name "${SAName}" \
          --sku Standard_LRS \
          --encryption-services blob
[[ $? -ne 0 ]] && echo -e "\n--SA ${SAName} Creation Failure" || echo -e "\n++SA ${SAName} Creation Success"

#To get the value
ACCOUNT_KEY=$(az storage account keys list --resource-group "${RGName}" --account-name "${SAName}" --query [0].value -o tsv)

#create container
echo "Creating the container to hold the terraform state"
az storage container create --name "${ConName_TF}" \
            --account-name "${SAName}" \
            --account-key "${ACCOUNT_KEY}"

[[ $? -ne 0 ]] && echo -e "\n--Container ${ConName_TF} Creation Failure" || echo -e "\n++Container ${ConName_TF} Creation Success"


#export the values required for Terraform
export TF_VAR_tenant_id="${tenantId}"
export TF_VAR_subscription_id="${subscriptionId}"

export TF_STATE_STORAGE_ACCOUNT_NAME="${SAName}"
export TF_STATE_CONTAINER_NAME="${ConName_TF}"

export ARM_TENANT_ID="${tenantId}"
export ARM_SUBSCRIPTION_ID="${subscriptionId}"
export ARM_CLIENT_ID="${ServicePrinicipalAppId}"
export ARM_CLIENT_SECRET="${password}"

cd ./IaC

terraform init \
        -backend-config="storage_account_name=$TF_STATE_STORAGE_ACCOUNT_NAME" \
        -backend-config="container_name=$TF_STATE_CONTAINER_NAME" \
        -backend-config="key=demoapp-terraform-arch-tfstate" \
        -backend-config="access_key=$ACCOUNT_KEY"
terraform plan -out=infra_plan.out
terraform apply -auto-approve infra_plan.out

#az logout
az logout