terraform {
  required_providers {
    twingate = {
      source  = "twingate/twingate"
      version = "~> 0.1.6"
    }
  }
}

provider "twingate" {
  api_token = var.twingate_api_key
  network   = var.twingate_network_slug
}



# Remote network configuration
variable "networks" {
  description = "Map of remote network configuration"
  type        = map
  default     = {
    "Production" = {
      connectors_per_remote_network  = 2
    },
    "Staging" = {
      connectors_per_remote_network  = 4
    }
  }
}



module "twingate_remote_networks" {
  source = "../../modules/remote-network"

  for_each = var.networks

  remote_network_name = each.key
  connectors_per_remote_network = each.value.connectors_per_remote_network
}

output "connectors" {
  value = { for rn in keys(var.networks) : rn => module.twingate_remote_networks[rn].connectors }
  sensitive = true
}
