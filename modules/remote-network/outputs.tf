output "connectors" {
 value = { for c in twingate_connector.connector[*] : c.id => merge(local.connectors_by_id[c.id], local.connector_tokens_by_id[c.id]) }
} 

locals {
 connectors_by_id = { for c in twingate_connector.connector[*] : c.id => {
     name = c.name
     remote_network_id = c.remote_network_id
   }
 }

 connector_tokens_by_id = { for ct in twingate_connector_tokens.connector_tokens[*] : ct.connector_id => {
     access_token = ct.access_token
     refresh_token = ct.refresh_token
   }
 }
}
