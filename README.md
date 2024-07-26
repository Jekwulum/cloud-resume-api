# Project Description
The Cloud Resume API is a serverless application that provides resume data in JSON format. Built using Azure Functions and CosmosDB, this project leverages Terraform for infrastructure as code (IaC) to manage and deploy the necessary resources on Azure. The API is designed to be easily deployable and scalable, making it a perfect choice for showcasing your resume in a modern, cloud-native manner.

# Project Structure
```shell
cloud_resume_api/
├── .github/
│   └── workflows/
│       └── deployment.yml
├── app/
│   ├── function_app.py
│   ├── host.json
│   ├── local.settings.json
│   ├── requirements.txt
│   ├── .env
│   ├── .funcignore
│   └── .venv/
├── terraform/
│   ├── cosmosdb.tf
│   ├── functions.tf
│   ├── main.tf
│   └── variables.tf
├── .gitignore
└── README.md
```

# Prerequisites
Before you begin, ensure you have the following installed on your local machine:
[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
[Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
[Python 3.9+](https://www.python.org/downloads/)
[Git](https://git-scm.com/downloads)

# Running the Application
1. Clone the repository:
    ```shell
    git clone git@github.com:Jekwulum/cloud-resume-api.git
    cd cloud-resume-api
    ```
2. Navigate to the app directory and create a virtual environment:
   ```shell
   cd app
   python -m venv .venv
   .venv\Scripts\activate  # On Linux use `source .venv/bin/activate`
   ```
3. Install the dependencies:
   ```shell
   pip install -r requirements.txt
   ```
4. Start the local Azure Functions runtime:
  ```shell
  func start
  ```
6. The API should now be running locally at `http://localhost:7071`. The resume is accessible via: `http://localhost:7071/api/resume?id=1`

# Deploying to Azure
1. **Log in to your Azure account using the Azure CLI:**
   ```shell
   az login
   ```
2. **Initialize Terraform and apply the configuration:**
   ```shell
   cd terraform
   terraform init # Initializes the Terraform working directory, downloading the necessary provider
   terraform fmt # Formats the Terraform files to ensure consistent styling
   terraform validate # Validates the Terraform files to ensure they are syntactically valid
   terraform plan # Generates an execution plan, showing what actions Terraform will take
   terraform apply # Apply Infrastructure Changes
   ```
3. **Set Environment Variables:**
Ensure you have a .env file in the root of your app directory with the necessary environment variables, such as:
  ```shell
    DB_CONNECTION_STRING=your_cosmosdb_connection_string
    DB_NAME=your_db_name
    DB_COLLECTION_NAME=your_collection_name
  ```
4. After Terraform completes, you can deploy the Function App using GitHub Actions. Ensure you have the following secrets set in your GitHub repository:
   - AZURE_CREDENTIALS (service principal credentials)
   - AZURE_FUNCTIONAPP_PUBLISH_PROFILE
   - AZURE_AD_CLIENT_ID

   - AZURE_AD_CLIENT_SECRET
   - AZURE_AD_TENANT_ID
   - AZURE_FUNCTIONAPP_PUBLISH_PROFILE
   - AZURE_SUBSCRIPTION_ID
Push your changes to the master branch to trigger the deployment workflow.

5. Set the request URL to `https://<your-function-app-name>.azurewebsites.net/api/resume?id=<document-id>`. For this poject, the endpoint is accessible via **[https://jkcloudresumeapi.azurewebsites.net/api/resume?id=1](https://jkcloudresumeapi.azurewebsites.net/api/resume?id=1)**