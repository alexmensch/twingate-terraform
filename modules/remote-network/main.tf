terraform {
  required_providers {
    twingate = {
      source  = "twingate/twingate"
      version = "~> 0.1.6"
    }
  }
}

resource "twingate_remote_network" "remote_network" {
  name = var.remote_network_name
}

resource "twingate_connector" "connector" {
  count = var.connectors_per_remote_network
  remote_network_id = twingate_remote_network.remote_network.id
}

resource "twingate_connector_tokens" "connector_tokens" {
  count = var.connectors_per_remote_network
  connector_id = twingate_connector.connector[count.index].id
}
