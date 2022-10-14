targetScope = 'resourceGroup'

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-devbox-papemk2'
  location: resourceGroup().location
  kind: 'app'
  sku: {
    name: 'B1'
    size: 'B1'
    tier: 'Basic'
    capacity: 1
  }
}

resource app 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-devbox-papemk2'
  location: resourceGroup().location
  dependsOn: [
    plan
  ]
  kind: 'app'
  properties: {
    serverFarmId: plan.id
  }
}
