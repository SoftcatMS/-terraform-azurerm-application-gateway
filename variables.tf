variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  default     = ""
}

variable "vnet_resource_group_name" {
  description = "The resource group name where the virtual network is created"
  default     = null
}

variable "subnet_name" {
  description = "The name of the subnet to use in VM scale set"
  default     = ""
}

variable "app_gateway_name" {
  description = "The name of the application gateway"
  default     = ""
}

variable "log_analytics_workspace_name" {
  description = "The name of log analytics workspace name"
  default     = null
}

variable "storage_account_name" {
  description = "The name of the hub storage account to store logs"
  default     = null
}

variable "domain_name_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN."
  default     = null
}

variable "enable_http2" {
  description = "Is HTTP2 enabled on the application gateway resource?"
  default     = false
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over."
  type        = list(string)
  default     = [] #["1", "2", "3"]
}

variable "firewall_policy_id" {
  description = "The ID of the Web Application Firewall Policy which can be associated with app gateway"
  default     = null
}

variable "sku" {
  description = "The sku pricing model of v1 and v2"
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

variable "autoscale_configuration" {
  description = "Minimum or Maximum capacity for autoscaling. Accepted values are for Minimum in the range 0 to 100 and for Maximum in the range 2 to 125"
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = null
}

variable "private_ip_address" {
  description = "Private IP Address to assign to the Load Balancer."
  default     = null
}

variable "backend_address_pools" {
  description = "List of backend address pools"
  type = list(object({
    name         = string
    fqdns        = list(string)
    ip_addresses = list(string)
  }))
}

variable "backend_http_settings" {
  description = "List of backend HTTP settings."
  type = list(object({
    name                                = string
    cookie_based_affinity               = string
    affinity_cookie_name                = string
    path                                = string
    enable_https                        = bool
    probe_name                          = string
    request_timeout                     = number
    host_name                           = string
    pick_host_name_from_backend_address = bool
    authentication_certificate = object({
      name = string
    })
    trusted_root_certificate_names = list(string)
    connection_draining = object({
      enable_connection_draining = bool
      drain_timeout_sec          = number
    })
  }))
}

variable "http_listeners" {
  description = "List of HTTP/HTTPS listeners. SSL Certificate name is required"
  type = list(object({
    name                 = string
    host_name            = string
    host_names           = list(string)
    require_sni          = bool
    ssl_certificate_name = string
    firewall_policy_id   = string
    ssl_profile_name     = string
    custom_error_configuration = list(object({
      status_code           = string
      custom_error_page_url = string
    }))
  }))
}

variable "request_routing_rules" {
  description = "List of Request routing rules to be used for listeners."
  type = list(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    redirect_configuration_name = string
    rewrite_rule_set_name       = string
    url_path_map_name           = string
  }))
  default = []
}

variable "identity_ids" {
  description = "Specifies a list with a single user managed identity id to be assigned to the Application Gateway"
  default     = null
}

variable "authentication_certificates" {
  description = "Authentication certificates to allow the backend with Azure Application Gateway"
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "trusted_root_certificates" {
  description = "Trusted root certificates to allow the backend with Azure Application Gateway"
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "ssl_policy" {
  description = "Application Gateway SSL configuration"
  type = object({
    disabled_protocols   = list(string)
    policy_type          = string
    policy_name          = string
    cipher_suites        = list(string)
    min_protocol_version = string
  })
  default = null
}

variable "ssl_certificates" {
  description = "List of SSL certificates data for Application gateway"
  type = list(object({
    name                = string
    data                = string
    password            = string
    key_vault_secret_id = string
  }))
  default = []
}

variable "health_probes" {
  description = "List of Health probes used to test backend pools health."
  type = list(object({
    name                                      = string
    host                                      = string
    interval                                  = number
    path                                      = string
    timeout                                   = number
    unhealthy_threshold                       = number
    port                                      = number
    pick_host_name_from_backend_http_settings = bool
    minimum_servers                           = number
    match = object({
      body        = string
      status_code = list(string)
    })
  }))
  default = []
}

variable "url_path_maps" {
  description = "List of URL path maps associated to path-based rules."
  type = list(object({
    name                                = string
    default_backend_http_settings_name  = string
    default_backend_address_pool_name   = string
    default_redirect_configuration_name = string
    default_rewrite_rule_set_name       = string
    path_rules = list(object({
      name                        = string
      backend_address_pool_name   = string
      backend_http_settings_name  = string
      paths                       = list(string)
      redirect_configuration_name = string
      rewrite_rule_set_name       = string
      firewall_policy_id          = string
    }))
  }))
  default = []
}

variable "redirect_configuration" {
  description = "list of maps for redirect configurations"
  type        = list(map(string))
  default     = []
}

variable "custom_error_configuration" {
  description = "Global level custom error configuration for application gateway"
  type        = list(map(string))
  default     = []
}

variable "rewrite_rule_set" {
  description = "List of rewrite rule set including rewrite rules"
  type        = any
  default     = []
}

variable "waf_configuration" {
  description = "Web Application Firewall support for your Azure Application Gateway"
  type = object({
    firewall_mode            = string
    rule_set_version         = string
    file_upload_limit_mb     = number
    request_body_check       = bool
    max_request_body_size_kb = number
    disabled_rule_group = list(object({
      rule_group_name = string
      rules           = list(string)
    }))
    exclusion = list(object({
      match_variable          = string
      selector_match_operator = string
      selector                = string
    }))
  })
  default = null
}

variable "agw_diag_logs" {
  description = "Application Gateway Monitoring Category details for Azure Diagnostic setting"
  default     = ["ApplicationGatewayAccessLog", "ApplicationGatewayPerformanceLog", "ApplicationGatewayFirewallLog"]
}

variable "pip_diag_logs" {
  description = "Load balancer Public IP Monitoring Category details for Azure Diagnostic setting"
  default     = ["DDoSProtectionNotifications", "DDoSMitigationFlowLogs", "DDoSMitigationReports"]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
