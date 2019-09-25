#initial setup
provider "google" {
    credentials = file("yourServiceAccountKey.json")
    
    project     = "yourProjectID"
    region      = "yourDesiredRegion"
    zone        = "yourDesiredZone"
}

#setup variable
variable "prefix" {
    default = "terra"
}

variable "region" {
    default = "asia-southeast1"
}

variable "zone" {
    default = "asia-southeast1-a"
}

variable "tags" {
    default = ["aks","devops"]
}

#setup for VPC network
resource "google_compute_network" "terra_vpc_network" {
    name = "${var.prefix}-network"
}

#setup for Compute Engine
resource "google_compute_instance" "terra_vm_instance" {
    depends_on   = [google_compute_address.terra_vm_ip, 
                    google_compute_network.terra_vpc_network]

    name         = "${var.prefix}-instance"
    zone         = "${var.zone}"
    machine_type = "f1-micro"
    tags         = "${var.tags}"

    boot_disk {
        initialize_params {
            image = "cos-cloud/cos-stable"
        }
    }

    network_interface {
        network = "${google_compute_network.terra_vpc_network.self_link}"
        
        access_config {
            nat_ip = "${google_compute_address.terra_vm_ip.address}"
        }
    }
}

resource "google_compute_address" "terra_vm_ip" {
    name = "${var.prefix}-static-ip"
}

resource "google_compute_firewall" "terra_firewall" {
    depends_on    = [google_compute_network.terra_vpc_network]

    name          = "${var.prefix}-firewall"
    network       = "${google_compute_network.terra_vpc_network.name}"
    source_ranges = ["0.0.0.0/0"]

    allow {
        protocol = "tcp"
        ports    = ["22","80","443"]
    }
}

#setup for Kubernetes Engine
resource "google_container_cluster" "terra_kube" {
    depends_on         = [google_compute_network.terra_vpc_network]

    name               = "${var.prefix}-cluster"
    network            = "${google_compute_network.terra_vpc_network.name}"
    location           = "${var.region}"
    initial_node_count = 1  

    addons_config {
        http_load_balancing {
            disabled = false
        }

        horizontal_pod_autoscaling {
            disabled = false
        }

        kubernetes_dashboard {
            disabled = false
        }
    }
}

#setup managed pool instead of defaul pool
resource "google_container_node_pool" "terra_kube_nodes" {
    depends_on         = [google_container_cluster.terra_kube]

    name               = "${var.prefix}-node-pool"
    location           = "${var.region}"
    cluster            = "${google_container_cluster.terra_kube.name}"
    initial_node_count = 1

    management {
        auto_repair  = true
        auto_upgrade = false
    }

    node_config {
        disk_size_gb = 10
        disk_type    = "pd-standard"
        preemptible  = false
        machine_type = "n1-standard-1"

        metadata = {
            disable-legacy-endpoints = true
        }

      oauth_scopes = ["https://www.googleapis.com/auth/logging.write",
                      "https://www.googleapis.com/auth/monitoring",
                      "https://www.googleapis.com/auth/cloud-platform"]
    }
}
