resource "google_compute_address" "prod_ip_address" {
  name = "watchtower-production-v2"
}

resource "google_compute_address" "staging_ip_address" {
  name = "watchtower-staging-v2"
}
