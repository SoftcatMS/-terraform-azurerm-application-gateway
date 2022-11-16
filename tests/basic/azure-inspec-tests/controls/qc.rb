# copyright: 2018, The Authors

# Test values

resource_group1 = 'rg-test-appgw-basic-resources'

describe azure_application_gateway(resource_group: resource_group1, name: 'appgw-test-basic-uksouth') do
  it              { should exist }
  its('location') {should cmp 'uksouth'}
  its('properties.sku.name') { should cmp 'Standard_v2' }
end