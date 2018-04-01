describe azure_resource_group(name: 'amido-uks-cb170-rg-bot-dev') do
  its('location') { should eq 'uksouth' }
end
