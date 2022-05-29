# Twingate

variable "twingate_api_key" {
  description = "API key for Twingate tenant"
  type        = string
  sensitive   = true
}

variable "twingate_network_slug" {
  description = "Twingate network slug (subdomain)"
  type        = string
}
