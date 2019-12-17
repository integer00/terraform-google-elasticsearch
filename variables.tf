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

variable "project_id" {
  description = "The project ID to deploy to"
}

variable "es_vm_count" {
  default = 1
}

variable "es_instance_machine_type" {
  default = "n1-standard-1"
}

variable "es_instance_zone" {
  default = "europe-west2-a"
}

variable "es_metadata" {
  type    = map(string)
  default = {}
}
variable "es_network" {
  default = "default"
}
variable "es_subnetwork" {
  default = "default"
}
variable "es_tags" {
  default = []
  type    = list(string)
}
variable "es_instance_name" {
  default = "elasticsearch-vm-node"
}
variable "es_disk_type" {
  default = "pd-standard"
}
variable "es_disk_size" {
  default = "20"
}
variable "es_instance_image" {
  default = "centos-7"
}
variable "es_instance_region" {
  default = "europe-west2"
}
variable "es_heap_size" {
  description = "The heapsize of jvm"
  default = "1g"
}
variable "es_cluster_name" {
  description = "A name for cluster"
  default = "elastic-cluster"
}