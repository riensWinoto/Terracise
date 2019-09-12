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
    
    
##
Feel free to use it and modify it.

Let me know if something wrong or strange happen just email me at: rienslw@outlook.com

Thank You :D
