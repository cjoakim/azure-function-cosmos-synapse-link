#!/bin/bash

# Bash shell that defines parameters and environment variables used 
# in this app, and is "sourced" by the other scripts in this repo.
# Chris Joakim, 2020/10/10

export subscription=$AZURE_SUBSCRIPTION_ID
export user=$USER
export primary_region="eastus"
export primary_rg="cjoakimsynapse2"

export storage_rg=$primary_rg
export storage_region=$primary_region
export storage_name="cjoakimsynapse2f"
export storage_kind="BlobStorage"     # {BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2}]
export storage_sku="Standard_LRS"     # {Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, , Standard_RAGRS, Standard_RAGZRS, Standard_ZRS]
export storage_access_tier="Hot"      # Cool, Hot

export functionapp_rg=$primary_rg
export functionapp_region=$primary_region
export functionapp_name="cjoakimsynapse2f"
