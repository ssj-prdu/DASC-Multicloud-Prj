resource "google_compute_network" "dasc_vpc_main_network" {
  name = "dasc-vpc-main"
  auto_create_subnetworks = false
}
