# Terracise
Terraform exercise using Cloud Computing Service. Develop as much as possible from various Cloud Provider.


## Setup for Terraform binary
Must download the binary from Terraform official website and setup it based on your OS.

In my case, I'm using Ubuntu so I setup the path to **/etc/environment**.

Add your Terraform binary path to the PATH value, example: **":/home/yourname/"**.

After that use command **source /etc/environment** to enabled terraform binary from anywhere.


## Setup for Terraform-GCP
Setup for GCP must provide **service account key**, **project id**, **zone**, and **region**.

Use the **serviceAccountKey.json** for easier access to GCP.

To get that service account key, we need to do this steps:
  - Open your GCP and navigate to **APIs & Services** navigation then choose **Credentials**.
  
  - **Create credentials** and choose **Service account key**.
  
  - **Create new service account** and fill the requirement such as **service account name** and **role**.
  
  - For **role** it's up to you but better select **Editor** from Project navigation for access to all resources.
  
  - For **Key type** choose **JSON** after that you will get your **service account key**.
  
NB: **Save your serviceAccountKey.json carefully**, **once you lost it you must create new service account key**.

If Kubernetes (cluster) not needed just multi-line comment along side with the node pool configuration.

For oauth_scopes, adjust with your needs, for more APIs URL see this [Google Scopes](https://developers.google.com/identity/protocols/googlescopes).


## Setup for Terraform-Azure
Setup for Azure must provide **credential ID**, **client secret**, **subscription ID**, and **tenant ID**.

To get that all, we need **Service Principal** that has **Contributor** rights. Follow this step to get that:

  - Open **Azure Cloud Shell** then login using **az login**.
  
  - Check your **subscription ID** using **az account list** that displayed as **id**.
  
  - Create service principal credential using this command:
  ```
     az ad sp create-for-rbac --name="freeName" --role="Contributor" --scopes="/subscriptions/YourSubscription ID"
  ```
  
  - After that better change the password we easier to remember using this command **(optional)**:
  ```
    az ad sp credential reset --name="freeName" --password="YourNewPass"
  ```
  
  - We can display our service principal credential using this command:
  ```
    az ad sp list --display-name="freeName"
  ```
  
  - That command will displaying our service principal credential, just notice the **appDisplayName**, **appId**, and **appOwnerTenantId**.
    
    We will use the **appId** and **appOwnerTenantId** when login to our credential.
    
    
  - Try to login to our credential using this command:
  ```
    az login --service-principal --username="appId" --password="yourPassword" --tenant="appOwnerTenantId"
  ```
  
  - If it succeed then we can use it for **TerraciseAzure script**. Remember this mapping:
    - **appId** is **client_id** 
    - **appOwnerTenantId** is **tenant_id**
    - **yourPassword** is **client_secret**
    - **subscription ID** is **subscription_id**
    
    
## Setup for Terraform-IBM
Setup for IBM must provide **API Key**, **Terraform Plugin**

Because IBM Cloud not default by **Terraform**, so we need to install the plugin separately:

  - Download the IBM Cloud binary package **[here](https://github.com/IBM-Cloud/terraform-provider-ibm/releases)**.
    After finish download, extract the package and retrieve the binary file.

  - Create hidden folder for the plugin:
    ```
        mkdir $HOME/.terraform.d/plugins
    ```

  - Move the plugin to the hidden folder, verify the installation is complete, the output must be like this:
    ```
        2018/09/25 17:30:14 IBM Cloud Provider version 0.11.3  fdc4aa0f0547177f3ea8b14c7a58a849e240f64a
        This binary is a plugin. These are not meant to be executed directly.
        Please execute the program that consumes these plugins, which will load any plugins automatically
    ``` 

Don't forget the **API Key**, needed to access the Cloud:

  - In the IBM Cloud console, go to **Manage > Access (IAM) > API keys**.
  - Click Create an IBM Cloud API key.
  - Enter a name and description for your API key.
  - Click Create.
  - Then, click Show to display the API key. Or, click Copy to copy and save it for later, or click Download.

**NB: For security reasons, the API key is only available to be copied or downloaded at the time of creation. 
If the API key is lost, you must create a new API key.**

    
Feel free to use it and modify it.

Let me know if something wrong or strange happen just email me at: rienslw@outlook.com

Thank You :D
