# azure-function-cosmos-synapse-link

---

## Deploying this Solution

Assumptions:
- Host commputer is Linux, macOS, or Windows 10 with the Windows Subsystem for Linux (WSL)
  - See https://docs.microsoft.com/en-us/windows/wsl/install-win10
- git is installed
- python 3.7.x is installed
- pyenv is installed
- Azure Function Tools are installed
  - See https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local
- Azure CLI is installed
  - See https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

### Programming Languages

Python3 is the client-side and Azure Function implementation language, and PySpark is used in Azure Synapse.

The **pyenv** Python Version Management tool is used to manage Python versions and virtual environments;
see the **pyenv.sh** shell scripts in this repo.

### Provision Azure Resources

- Create an Azure Storage Account in Azure Portal 
- Create an Azure Function App with the Azure CLI
  - see automation/az/functionapp.sh, reference the above storage account 
- Create an Azure CosmosDB account, with SQL API, in Azure Portal
  - Create a database named **dev**, and a container named **plants** with partition key **/pk**
- Create an Azure Synapse Workspace, with Spark Pool, in Azure Portal

- Set environment variables AZURE_COSMOSDB_SQLDB_URI and AZURE_COSMOSDB_SQLDB_KEY
  - Obtain these values in Azure Portal in your CosmosDB Settings --> Keys panel
    - AZURE_COSMOSDB_SQLDB_URI
    - AZURE_COSMOSDB_SQLDB_KEY
  - Set these environment variables both on your workstation and in your Azure Function App
  
```
$ git clone https://github.com/cjoakim/azure-function-cosmos-synapse-link.git
$ cd azure-function-cosmos-synapse-link
```


#### Notes: Creating a Python-based Azure Function App

These steps use the Azure Function Tools.

```
$ func init --help
$ func init FunctionApp --worker-runtime python
$ cd FunctionApp
$ func new --name CosmosPlantsUpdate --template "HTTP trigger"
$ func extensions install
$ ./pyenv.sh create

  ... edit the generated CosmosPlantsUpdate/__init__.py file, which implements the Function ...

$ func start
Now listening on: http://0.0.0.0:7071
Application started. Press Ctrl+C to shut down.
Functions:
	CosmosPlantsUpdate: [GET,POST] http://localhost:7071/api/CosmosPlantsUpdate
```

Invoke the HTTP Function, running locally, from another Terminal in the pybatch directory

```
$ python main.py post_to_azure_function local
```

After you're satisfied with how the Function runs locally, deploy it to Azure:

```
$ func azure functionapp publish $app_name
  - or -
$ ./deploy.sh
```

