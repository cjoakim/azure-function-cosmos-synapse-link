#!/bin/bash

# Bash script with AZ CLI to automate the creation of an Azure Function App.
# Chris Joakim, 2020/10/10

# az login

source config.sh

az functionapp create \
  --resource-group $functionapp_rg \
  --os-type Linux \
  --consumption-plan-location $functionapp_region \
  --runtime python \
  --runtime-version 3.7 \
  --functions-version 2 \
  --name $functionapp_name \
  --storage-account $storage_name
