provider "google" {
  project = "${var.taito_resource_namespace_id}"
  region = "${var.gcloud_region}"
  zone = "${var.gcloud_zone}"
}