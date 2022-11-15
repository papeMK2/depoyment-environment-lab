targetScope = 'resourceGroup'

@secure()
param adminPassword string

@secure()
param adminName string

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

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: 'sql-devbox-papemk2'
  location: resourceGroup().location
  tags: {}
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    minimalTlsVersion: '1.2'
    administratorLogin: adminName
    administratorLoginPassword: adminPassword
    administrators: {
      login: adminName
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: false
      // principalType: 'Group'
      // sid: adminGroupObjectId
      // tenantId: tenantId
    }
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  name: '${sqlServer.name}/sqldb-devbox-papemk2'
  location: resourceGroup().location
  tags: {}
  sku: {
    name: 'GP_S_Gen5'
    capacity: 1
  }
  properties: {
    collation: 'Japanese_CI_AS'
    catalogCollation: 'DATABASE_DEFAULT'
    zoneRedundant: false
    readScale: 'Disabled'
    minCapacity: json('0.5')
  }
}
