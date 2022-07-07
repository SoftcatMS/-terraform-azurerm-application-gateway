resource "azurerm_resource_group" "rg-appgw-test-basic" {
  name     = "rg-test-appgw-basic-resources"
  location = "UK South"
}

resource "azurerm_user_assigned_identity" "appgw-user-test-basic" {
  resource_group_name = azurerm_resource_group.rg-appgw-test-basic.name
  location            = azurerm_resource_group.rg-appgw-test-basic.location
  name                = "appgw-api-test-basic"
}

module "vnet" {

  source              = "github.com/SoftcatMS/azure-terraform-vnet"
  vnet_name           = "vnet-test-basic"
  resource_group_name = azurerm_resource_group.rg-appgw-test-basic.name
  address_space       = ["10.1.0.0/16"]
  subnet_prefixes     = ["10.1.1.0/24"]
  subnet_names        = ["subnet1"]

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  depends_on = [azurerm_resource_group.rg-appgw-test-basic]
}

module "application-gateway" {
  source = "../../"

  resource_group_name  = azurerm_resource_group.rg-appgw-test-basic.name
  location             = azurerm_resource_group.rg-appgw-test-basic.location
  virtual_network_name = module.vnet.vnet_name
  subnet_name          = "subnet1"
  app_gateway_name     = "appgw-test-basic"

  # SKU requires `name`, `tier` to use for this Application Gateway
  # `Capacity` property is optional if `autoscale_configuration` is set
  sku = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  # A backend pool routes request to backend servers, which serve the request.
  # Can create different backend pools for different types of requests
  backend_address_pools = [
    {
      name  = "appgw-testgateway-basic-uksouth-bapool01"
      fqdns = ["example1.com", "example2.com"]
    },
    {
      name         = "appgw-testgateway-basic-uksouth-bapool02"
      ip_addresses = ["1.2.3.4", "2.3.4.5"]
    }
  ]

  # An application gateway routes traffic to the backend servers using the port, protocol, and other settings
  # The port and protocol used to check traffic is encrypted between the application gateway and backend servers
  # List of backend HTTP settings can be added here.  
  # `probe_name` argument is required if you are defing health probes.
  backend_http_settings = [
    {
      name                  = "appgw-testgateway-basic-uksouth-be-http-set1"
      cookie_based_affinity = "Disabled"
      path                  = "/"
      enable_https          = false
      request_timeout       = 30
      probe_name            = "appgw-testgateway-uksouth-probe1" # Remove this if `health_probes` object is not defined.
      connection_draining = {
        enable_connection_draining = true
        drain_timeout_sec          = 300

      }
    },
    {
      name                  = "appgw-testgateway-basic-uksouth-be-http-set2"
      cookie_based_affinity = "Enabled"
      path                  = "/"
      enable_https          = false
      request_timeout       = 30
    }
  ]

  # List of HTTP/HTTPS listeners. SSL Certificate name is required
  # `Basic` - This type of listener listens to a single domain site, where it has a single DNS mapping to the IP address of the 
  # application gateway. This listener configuration is required when you host a single site behind an application gateway.
  # `Multi-site` - This listener configuration is required when you want to configure routing based on host name or domain name for 
  # more than one web application on the same application gateway. Each website can be directed to its own backend pool.
  # Setting `host_name` value changes Listener Type to 'Multi site`. `host_names` allows special wildcard charcters.
  http_listeners = [
    {
      name      = "appgw-testgateway-basic-uksouth-be-htln01"
      host_name = null
    }
  ]

  # Request routing rule is to determine how to route traffic on the listener. 
  # The rule binds the listener, the back-end server pool, and the backend HTTP settings.
  # `Basic` - All requests on the associated listener (for example, blog.contoso.com/*) are forwarded to the associated 
  # backend pool by using the associated HTTP setting.
  # `Path-based` - This routing rule lets you route the requests on the associated listener to a specific backend pool, 
  # based on the URL in the request. 
  request_routing_rules = [
    {
      name                       = "appgw-testgateway-basic-uksouth-be-rqrt"
      rule_type                  = "Basic"
      http_listener_name         = "appgw-testgateway-basic-uksouth-be-htln01"
      backend_address_pool_name  = "appgw-testgateway-basic-uksouth-bapool01"
      backend_http_settings_name = "appgw-testgateway-basic-uksouth-be-http-set1"
    }
  ]

  health_probes = [
    {
      name                = "appgw-testgateway-uksouth-probe1"
      host                = "127.0.0.1"
      interval            = 30
      path                = "/"
      port                = 80
      timeout             = 30
      unhealthy_threshold = 3
    }
  ]

  # A list with a single user managed identity id to be assigned to access Keyvault
  identity_ids = [azurerm_user_assigned_identity.appgw-user-test-basic.id]

  # (Optional) To enable Azure Monitoring for Azure Application Gateway
  # (Optional) Specify `storage_account_name` to save monitoring logs to storage. 
  #log_analytics_workspace_name = "loganalytics-uks-basic-test"

  # Adding TAG's to Azure resources
  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  depends_on = [module.vnet]

}
