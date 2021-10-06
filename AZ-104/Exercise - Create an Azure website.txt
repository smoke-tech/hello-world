#Exercise - Create an Azure website using the CLI
#Using a resource group

export RESOURCE_GROUP=learn-27243be6-f11d-4f05-9412-1180cbd65a96
export AZURE_REGION=centralus
export AZURE_APP_PLAN=popupappplan-$RANDOM
export AZURE_WEB_APP=popupwebapp-$RANDOM


az group list --output table

az group list --query "[?name == '$RESOURCE_GROUP']"

#Steps to create a service plan

az appservice plan create --name $AZURE_APP_PLAN --resource-group $RESOURCE_GROUP --location $AZURE_REGION --sku FREE

az appservice plan list --output table

# Steps to create a web app
az webapp create --name $AZURE_WEB_APP --resource-group $RESOURCE_GROUP --plan $AZURE_APP_PLAN
az webapp list --output table
curl $AZURE_WEB_APP.azurewebsites.net


#Steps to deploy code from GitHub
az webapp deployment source config --name $AZURE_WEB_APP --resource-group $RESOURCE_GROUP --repo-url "https://github.com/Azure-Samples/php-docs-hello-world" --branch master --manual-integration
curl $AZURE_WEB_APP.azurewebsites.net

curl $AZURE_WEB_APP.azurewebsites.net