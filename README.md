#Introduction
A sample work to create an infrastructure to deploy containerized applications referenced in [Infra Problem](https://github.com/ThoughtWorksInc/infra-problem)

Have choosen Azure Cloud Platform for this task along with AKS

#Prequisites
- Azure CLI
- Azure Service Prinical Account with Contributor role on a subscription 
- Bash to run shell scripts
- kubectl

This project contains two Shell scripts
 - BuildInfra.sh - Takes care of building Azure infrastructure
 - BuildImage.sh - Takes care of building the docker images, pushing it to private registry and running a deployment in AKS


#Build and Run
Please create an Azure service principal to start with building the Infra. Below command can be used with CLI
az ad sp create-for-rbac -n testsp1 --role="Contributor" --scopes="/subscriptions/<subscriptionId>"

Please make a note of the output which is needed in next step

Run the shell script BuildInfra.sh to start with Azure infra. Script would prompt to provide Service Prinicipal details.
Please provide the requested input. Script will create a RG 'terraRG' with Storage Account and containter 'terraforminfrasa/demoappterrastate' to save the terraform state file 'demoapp-terraform-arch-tfstate'
Once the terraform backend is set. Script will start creating the azure services under IaC.

Run the shell script BuildImage.sh to start building the docker images for the applications, push it to private container registry and deploy it to AKS. Script would prompt to provide Service Prinicipal details.
Please provide the requested SP input. 

Once the deployment is complete please check for front-end service under kubernetes namespace demoapp and the external IP can be used to check the status of the application.
EIP=`kubectl get svc "front-end" --output=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n demoapp`

wget --server-response ${EIP}/ping 2>&1 | awk '/^  HTTP/{print $2}'

The task could have been done in a much better way with security, pipelines, azure services and modular coding which I was not able to complete.






