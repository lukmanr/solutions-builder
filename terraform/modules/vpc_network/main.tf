/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5.0"
  project_id   = var.project_id
  network_name = var.vpc_network
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name               = var.vpc_subnetwork
      subnet_ip                 = var.subnet_ip
      subnet_region             = var.region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
  ]

  secondary_ranges = {
    (var.vpc_subnetwork) = [
      var.secondary_ranges_pods,
      var.secondary_ranges_services,
    ]
  }

  # Create a firewall rule to allow master to use port 8443 to validate
  # the ingress in a private GKE cluster
  # Ref: https://github.com/elastic/cloud-on-k8s/issues/1437
  firewall_rules = [
    {
      name                    = "gke-ingress-nginx-webhook"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = var.master_cidr_ranges
      source_tags             = null
      source_service_accounts = null
      target_tags             = var.node_pools_tags
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["8443"]
      }]
      deny = []
      log_config = {
        metadata = "EXCLUDE_ALL_METADATA"
      }
    }
  ]
}

# resource "google_compute_network" "vpc_network" {
#   name = var.vpc_network
#   auto_create_subnetworks = true
# }

# module "vpc" {
#   source       = "terraform-google-modules/network/google"
#   version      = "~> 4.0"
#   project_id   = var.project_id
#   network_name = var.vpc_network
#   routing_mode = "GLOBAL"
#   auto_create_subnetworks = true
# }

# module "cloud-nat" {
#   source            = "terraform-google-modules/cloud-nat/google"
#   version           = "~> 1.2"
#   name              = format("%s-%s-nat", var.project_id, var.region)
#   create_router     = true
#   router            = format("%s-%s-router", var.project_id, var.region)
#   project_id        = var.project_id
#   region            = var.region
#   network           = module.vpc.network_id
#   log_config_enable = true
#   log_config_filter = "ERRORS_ONLY"
# }

# resource "google_compute_router" "router" {
#   name    = "${var.project_id}-router"
#   region  = var.region
#   network = google_container_cluster.main-cluster.network

#   bgp {
#     asn = 64514
#   }
# }

# resource "google_compute_router_nat" "nat" {
#   name                               = "router-nat"
#   router                             = google_compute_router.router.name
#   region                             = google_compute_router.router.region
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

#   log_config {
#     enable = true
#     filter = "ERRORS_ONLY"
#   }
# }
