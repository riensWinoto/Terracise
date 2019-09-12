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
