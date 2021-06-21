#!/bin/bash

ACR_Name="demoappac2registry.azurecr.io"
Services_List="quotes newsfeed front-end front-end-static"
Namespace="demoapp"


clear
echo "Enter the Azure SP details to continue"
echo -e "\nEnter the Service Principal App ID: \c"
read -s "ServicePrincipalAppId"
echo -e "\nEnter the Service Principal Password:\c "
read -s "password"
echo -e "\nEnter the Tenant ID: \c"
read -s "tenantId"

#echo "Login using the created SP Account for further steps"
az login --service-principal --username "${ServicePrincipalAppId}" --password "${password}" --tenant "${tenantId}"
[[ $? -ne 0 ]] && echo -e "\n--Login failure" || echo -e "\n++Login Success"

#subscription_details
subscriptionId=$(az account show --query id -o tsv)

az account set --subscription "${subscriptionId}"
az aks get-credentials --resource-group demoapp_rg --name "${Namespace}"

az acr login --name  "${ACR_Name}"
[[ $? -ne 0 ]] && echo -e "\n-- ${ACR_Name} Login failure" || echo -e "\n++ ${ACR_Name} Login Success"



#Download the Repo
[[ -d code ]] && rm -rf code
curl -LkSs https://github.com/ThoughtWorksInc/infra-problem/tarball/master \
 | tar -xpf - -C . && mv Thought* code

#Download the Lein package
curl -LkSs https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o lein
#curl -LkSs https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/leiningen-clojure/2.9.1-5/leiningen-clojure_2.9.1.orig.tar.gz | tar -xpf - -C . 


#Build the Docker images

for service in `echo ${Services_List}`
do
  docker build --target "${service}" -t "${ACR_Name}/sample/${service}":latest .
  [[ $? -ne 0 ]] && echo -e "\n--${service} Image Build failure" && continue || echo -e "\n++${service} Image Build Success"

  #docker push to repo
  docker push "${ACR_Name}/sample/${service}":latest
  [[ $? -ne 0 ]] && echo -e "\n--${service} Image Push to ${ACR_Name} failure" && continue || echo -e "\n++${service} Image Push to ${ACR_Name} Success"
done

##Perform the kubernetes deployment

[[ `kubectl get ns "${Namespace}" --output=jsonpath={.metadata.name} 2> /dev/null` = '' ]] &&  kubectl create ns "${Namespace}" || echo -e "${Namespace} already exists!"
kubectl apply -f deployment.yaml -n "${Namespace}"
[[ $? -ne 0 ]] && echo -e "\n-- Deployment failure" || echo -e "\n++ Deployment Success"

sleep 15

kubectl get deploy,po,svc -n "${Namespace}"

echo -e "\nCheck front-end with External IP with ping"
EIP=`kubectl get svc "front-end" --output=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n "${Namespace}"`
wget --server-response ${EIP}/ping 2>&1 | awk '/^  HTTP/{print $2}'

#Logout
az logout
 
