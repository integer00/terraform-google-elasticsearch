/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  local_es_metadata = {
    startup-script = data.template_file.init_es.rendered

    es_config = data.template_file.es_config.rendered
    es_jvm_options = data.template_file.jvm_options.rendered


  }
  local_es_tags     = ["elastic-external"]

}

data "template_file" "init_es" {
  template = file("${path.module}/templates/init_elasticsearch.tpl")
}

//resource "random_uuid" "shuff" {
// count = var.es_vm_count
//
//}

data "template_file" "es_config" {

  template = file("${path.module}/templates/elasticsearch.json.tpl")

  vars = {
    initial_master_ip = google_compute_address.elasticsearch_vm_internal_address[0].address
    internal_ip = join(", " , google_compute_address.elasticsearch_vm_internal_address[*].address)
    cluster_name = var.es_cluster_name

  }
}

data "template_file" "jvm_options" {
  template = file("${path.module}/templates/jvm.options.tpl")

  vars = {
    heap_size = var.es_heap_size
  }
}

data "google_compute_network" "data_network" {
  project = var.project_id
  name    = var.es_network
}

data "google_compute_subnetwork" "data_subnetwork" {
  project = var.project_id
  name    = var.es_subnetwork
  region  = var.es_instance_region
}



resource "google_compute_instance" "elasticsearch_vm" {
  project      = var.project_id
  name         = "${var.es_instance_name}${count.index}"
  count        = var.es_vm_count
  machine_type = var.es_instance_machine_type
  zone         = var.es_instance_zone
  tags = concat(
    local.local_es_tags,
    var.es_tags
  )

  allow_stopping_for_update = "false"

  boot_disk {
    source = google_compute_disk.elasticsearch_vm_disk[count.index].name
  }

  metadata = merge(
    local.local_es_metadata,
    var.es_metadata
  )

  network_interface {
    subnetwork = data.google_compute_subnetwork.data_subnetwork.self_link
    network_ip = google_compute_address.elasticsearch_vm_internal_address[count.index].address

    access_config {

    }
  }

}


resource "google_compute_disk" "elasticsearch_vm_disk" {
  project = var.project_id
  name    = "${var.es_instance_name}${count.index}-disk"
  count   = var.es_vm_count
  type    = var.es_disk_type
  size    = var.es_disk_size
  zone    = var.es_instance_zone
  image   = var.es_instance_image

  physical_block_size_bytes = 4096
}



resource "google_compute_address" "elasticsearch_vm_internal_address" {
  project    = var.project_id
  count      = var.es_vm_count
  name       = "${var.es_instance_name}${count.index}-internal-address"
  region     = var.es_instance_region
  subnetwork = data.google_compute_subnetwork.data_subnetwork.name

  address_type = "INTERNAL"
}

//resource "google_compute_address" "vm_elastic_external_address" {
//  count = "2"
//  name   = "elastic-public-ip-${count.index}"
//  region = var.region
//}

resource "google_compute_firewall" "vm_elastic_allow_external" {
  project = var.project_id
  name    = "${var.es_instance_name}-firewall-rule"
  network = data.google_compute_network.data_network.name

  allow {
    protocol = "tcp"
    ports    = ["9200","9300"]
  }

  source_tags = ["elastic-external"]
}