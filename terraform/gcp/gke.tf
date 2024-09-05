resource "google_container_cluster" "dasc_cluster" {
  name               = "dasc-cluster-was"
  location           = var.region

  networking_mode    = "VPC_NATIVE"
  subnetwork         = var.subnet-main

  initial_node_count = 1

  node_config {
    machine_type = "e2-micro"
    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  remove_default_node_pool = true

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  network = var.vpc
}

resource "google_container_node_pool" "dasc_node_pool" {
  cluster  = google_container_cluster.dasc_cluster.name
  location = var.region

  node_count = 3

  autoscaling {
    min_node_count = 3
    max_node_count = 3
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = "e2-micro"
  }

  node_locations = [
    "${var.region}-a",
    "${var.region}-b",
    "${var.region}-c",
  ]
}