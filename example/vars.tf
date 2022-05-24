# Twingate

variable "twingate_api_key" {
  description = "API key for Twingate tenant"
  type        = string
	sensitive 	= true
}

variable "twingate_network_slug" {
  description = "Twingate network slug (subdomain)"
  type        = string
  default     = "moveolabs"
}

variable "demo_network_name" {
  description = "Name of remote network for demo"
  type        = string
  default     = "Device Security Demo"
}

variable "demo_resource_group_ids" {
  description = "List of group IDs for demo resource"
  type        = list(any)
  # default     = ["R3JvdXA6MTA0"] # Everyone group
  default     = ["R3JvdXA6MzM0OTM=","R3JvdXA6MzM0OTQ="] # Employees and Contractors groups
}


# AWS

variable "aws_access_key" {
	description	= "AWS access key"
  type    		= string
	sensitive		= true
}

variable "aws_secret_key" {
	description	= "AWS secret key"
  type    		= string
	sensitive		= true
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

