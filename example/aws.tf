resource "aws_key_pair" "alex" {
  key_name = "terraform-alex"
  public_key = var.ssh_public_key
}

data "aws_ami" "latest" {
  most_recent = true
  filter {
    name = "name"
    values = [
      "twingate/images/hvm-ssd/twingate-amd64-*",
    ]
  }
  owners = ["617935088040"]
}

module "demo_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = "Alex-Demo-VPC-Terraform"
  cidr = "10.0.0.0/16"

  azs                            = ["us-west-2a"]
  private_subnets                = ["10.0.1.0/24"]
  public_subnets                 = ["10.0.2.0/24"]
  enable_classiclink_dns_support = true
  enable_dns_hostnames           = true
  enable_nat_gateway             = true

}

module "demo_sg" {
  source             = "terraform-aws-modules/security-group/aws"
  version            = "3.17.0"
  vpc_id             = module.demo_vpc.vpc_id
  name               = "demo_security_group"
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-tcp", "all-udp", "all-icmp"]
  ingress_cidr_blocks = ["10.0.1.0/24"]
  ingress_rules      = ["all-tcp", "all-udp", "all-icmp"]
}

# spin off a ec2 instance from Twingate AMI and configure tokens in user_data
module "ec2_tenant_connector" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.19.0"
  
  count = 2

  name                   = "demo_connector"
  user_data              = <<-EOT
    #!/bin/bash
    set -e
    mkdir -p /etc/twingate/
    {
      echo TWINGATE_URL="https://${var.twingate_network_slug}.twingate.com"
      echo TWINGATE_ACCESS_TOKEN="${twingate_connector_tokens.demo_connector_tokens[count.index].access_token}"
      echo TWINGATE_REFRESH_TOKEN="${twingate_connector_tokens.demo_connector_tokens[count.index].refresh_token}"
    } > /etc/twingate/connector.conf
    sudo systemctl enable --now twingate-connector
  EOT
  ami                    = data.aws_ami.latest.id
  instance_type          = "t3a.micro"
  vpc_security_group_ids = [module.demo_sg.this_security_group_id]
  subnet_id              = module.demo_vpc.private_subnets[0]
}

# Spin up another EC2 instance and run a simple web server on it
module "ec2_web_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.19.0"

  name                   = "demo_web_server"
  user_data              = <<EOF
#!/bin/bash
sleep 60
sudo apt update
sudo apt install apache2 -y
EOF
  ami                    = "ami-0ee8244746ec5d6d4"
  instance_type          = "t3a.micro"
  vpc_security_group_ids = [module.demo_sg.this_security_group_id]
  subnet_id              = module.demo_vpc.private_subnets[0]
  key_name               = resource.aws_key_pair.alex.key_name

}
