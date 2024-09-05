resource "google_compute_network" "dasc_vpc_main_network" {
  name = var.vpc
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dasc-subnet-main" {
    name = var.subnet-main
  network = google_compute_network.dasc_vpc_main_network.id
  region = var.region
  ip_cidr_range = "192.168.128.0/23"

    secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.4.0.0/14"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.8.0.0/20"
  }
}