resource "google_compute_network" "dasc_vpc_main_network" {
  name = var.vpc
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dasc-subnet-main" {
    name = var.subnet-main
  network = google_compute_network.dasc_vpc_main_network.id
  region = var.region
  ip_cidr_range = "192.168.128.0/23"
}