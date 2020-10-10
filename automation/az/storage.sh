#!/bin/bash

# Bash script with AZ CLI to automate the creation/deletion of an Azure Storage account.
# Chris Joakim, 2020/10/10
#
# See https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest

# az login

source config.sh

arg_count=$#
processed=0

delete() {
    processed=1
    echo 'deleting storage rg: '$storage_rg
    az group delete \
        --name $storage_rg \
        --subscription $subscription \
        --yes \
        > tmp/storage_rg_delete.json
}

create() {
    processed=1
    echo 'creating storage rg: '$storage_rg
    az group create \
        --location $storage_region \
        --name $storage_rg \
        --subscription $subscription \
        > tmp/storage_rg_create.json

    # ValidationError: Storage account 'cjoakimsynapse2f' has no 'queue' 
    # endpoint. It must have table, queue, and blob endpoints all enabled
    # TODO: How enable the queue endpoint with 'az storage account create'?
    # I had to create the storage account in Portal before running functionapp.sh
    echo 'creating storage acct: '$storage_name
    az storage account create \
        --name $storage_name \
        --resource-group $storage_rg \
        --location $storage_region \
        --kind $storage_kind \
        --sku $storage_sku \
        --access-tier $storage_access_tier \
        --subscription $subscription \
        > tmp/storage_acct_create.json

    info
}

recreate() {
    processed=1
    delete
    create
    info 
}

info() {
    processed=1
    echo 'storage acct show: '$storage_name
    az storage account show \
        --name $storage_name \
        --resource-group $storage_rg \
        --subscription $subscription \
        > tmp/storage_acct_show.json

    echo 'storage acct keys: '$storage_name
    az storage account keys list \
        --account-name $storage_name \
        --resource-group $storage_rg \
        --subscription $subscription \
        > tmp/storage_acct_keys.json
}

display_usage() {
    echo 'Usage:'
    echo './storage.sh delete'
    echo './storage.sh create'
    echo './storage.sh recreate'
    echo './storage.sh info'
}

# ========== "main" logic below ==========

if [ $arg_count -gt 0 ]
then
    for arg in $@
    do
        if [ $arg == "delete" ];   then delete; fi 
        if [ $arg == "create" ];   then create; fi 
        if [ $arg == "recreate" ]; then recreate; fi 
        if [ $arg == "info" ];     then info; fi 
    done
fi

if [ $processed -eq 0 ]; then display_usage; fi

echo 'done'
