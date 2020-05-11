variable "prefix" {
  default = "terra-ibm-lite"
}

variable "ibm_api_key" {
  default = "your IBM API key"
}

provider "ibm" {
  ibmcloud_api_key = "${var.ibm_api_key}"
}

data "ibm_resource_group" "resource_group" {
  name = "Default"
}

#setup for Kubernetes cluster (Free)
resource "ibm_container_cluster" "terra-cluster" {
  name                    = "${var.prefix}"
  datacenter              = "dal10"
  machine_type            = "free"
  hardware                = "shared"
  region                  = "us-south"
  public_service_endpoint = true
}


resource "ibm_resource_instance" "terra-obj-storage" {
  depends_on        =  ["ibm_container_cluster.terra-cluster"]
  name              = "${var.prefix}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  service           = "cloud-object-storage"
  plan              = "lite"
  location          = "global"
}

resource "ibm_cos_bucket" "standard-ams03" {
  bucket_name          = "${var.prefix}-std"
  resource_instance_id = "${ibm_resource_instance.terra-obj-storage.id}"
  single_site_location = "ams03"
  storage_class        = "standard"
}

resource "ibm_cos_bucket" "vault-hkg02" {
  bucket_name          = "${var.prefix}-vault"
  resource_instance_id = "${ibm_resource_instance.terra-obj-storage.id}"
  single_site_location = "hkg02"
  storage_class        = "vault"
}