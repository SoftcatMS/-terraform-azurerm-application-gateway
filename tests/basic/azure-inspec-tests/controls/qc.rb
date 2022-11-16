# copyright: 2018, The Authors

# Test values

resource_group1 = 'rg-test-appgw-basic-resources'

describe azure_application_gateway(resource_group: resource_group1, name: 'appgw-test-basic') do
  it              { should exist }
  its('properties.sku.name') { should cmp 'Standard_v2' }
  its('properties.locations') { should cmp 'UK South' }
end