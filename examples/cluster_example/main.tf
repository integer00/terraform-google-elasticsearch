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

provider "google" {
  version = "~> 2.0"
}


resource "tls_private_key" "cluster_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "cluster_ca" {
  is_ca_certificate = true

  private_key_pem = tls_private_key.cluster_key.private_key_pem
  key_algorithm = "RSA"

  allowed_uses = []
  validity_period_hours = 43800

  subject {
    organization = "Organization"
  }
}

resource "tls_private_key" "cluster_client_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "cluster_cert_request" {
  key_algorithm = "RSA"
  private_key_pem = tls_private_key.cluster_client_key.private_key_pem

  subject {
    organization = "Organization"

  }
}

resource "tls_locally_signed_cert" "cluster_client_cert" {
  ca_cert_pem = tls_self_signed_cert.cluster_ca.cert_pem
  ca_private_key_pem = tls_private_key.cluster_key.private_key_pem
  ca_key_algorithm = "RSA"


  cert_request_pem = tls_cert_request.cluster_cert_request.cert_request_pem

  allowed_uses = []
  validity_period_hours = 43800
}

module "elasticsearch" {
  source = "../../"

  project_id = var.project_id
  es_vm_count = var.es_vm_count

  es_metadata = {

    es_ssl_ca = tls_self_signed_cert.cluster_ca.cert_pem
    es_ssl_key = tls_private_key.cluster_client_key.private_key_pem
    es_ssl_crt = tls_locally_signed_cert.cluster_client_cert.cert_pem
  }
}
