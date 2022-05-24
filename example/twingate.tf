resource "twingate_remote_network" "demo_network" {
  name = var.demo_network_name
}

resource "twingate_connector" "demo_connector" {
  count = 2
  remote_network_id = twingate_remote_network.demo_network.id
}

resource "twingate_connector_tokens" "demo_connector_tokens" {
  count = 2
  connector_id = twingate_connector.demo_connector[count.index].id
}

resource "twingate_resource" "employee_resource" {
  name              = "Employee Resource"
  address           = module.ec2_web_server.private_ip[0]
  remote_network_id = twingate_remote_network.demo_network.id
  group_ids         = var.demo_resource_group_ids
  protocols {
    allow_icmp = true
    tcp {
      policy = "RESTRICTED"
      ports  = ["80,443"]
    }
    udp {
      policy = "ALLOW_ALL"
    }
  }
}
