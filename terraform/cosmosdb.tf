resource "azurerm_cosmosdb_account" "main" {
  name                      = "cosmosmongo${var.application_name}"
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name
  offer_type                = "Standard"
  enable_automatic_failover = true
  kind                      = "MongoDB"

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

}

data "azurerm_cosmosdb_account" "mongodb" {
  name                = azurerm_cosmosdb_account.main.name
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name
}


resource "azurerm_cosmosdb_mongo_database" "main" {
  name                = "resumedb"
  resource_group_name = data.azurerm_cosmosdb_account.mongodb.resource_group_name
  account_name        = data.azurerm_cosmosdb_account.mongodb.name
  throughput          = 400
}

resource "azurerm_cosmosdb_mongo_collection" "main" {
  name                = "resumecollection"
  resource_group_name = data.azurerm_cosmosdb_account.mongodb.resource_group_name
  account_name        = data.azurerm_cosmosdb_account.mongodb.name
  database_name       = azurerm_cosmosdb_mongo_database.main.name

  default_ttl_seconds = "777"
  shard_key           = "uniqueKey"
  throughput          = 400

  index {
    keys   = ["_id"]
    unique = true
  }
}