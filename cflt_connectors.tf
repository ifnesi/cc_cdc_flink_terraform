# --------------------------------------------------------
# Service Accounts (Connectors)
# --------------------------------------------------------
resource "confluent_service_account" "connectors" {
  display_name = "connectors-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Access Control List (ACL)
# --------------------------------------------------------
resource "confluent_kafka_acl" "connectors_source_describe_cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
# Demo topics
resource "confluent_kafka_acl" "connectors_source_create_topic_demo" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "demo-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "CREATE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_source_write_topic_demo" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "demo-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "WRITE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_source_read_topic_demo" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "demo-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "READ"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_source_delete_topic_demo" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "demo-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "DELETE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
# DLQ topics (for the connectors)
resource "confluent_kafka_acl" "connectors_source_create_topic_dlq" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "CREATE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_source_write_topic_dlq" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "WRITE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_source_read_topic_dlq" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "READ"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
# Consumer group
resource "confluent_kafka_acl" "connectors_source_consumer_group" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "GROUP"
  resource_name = "connect"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "READ"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "cdc_source_consumer_group" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "GROUP"
  resource_name = "lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "READ"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Credentials / API Keys
# --------------------------------------------------------
resource "confluent_api_key" "connector_key" {
  display_name = "connector-${var.cc_cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.connectors.id
    api_version = confluent_service_account.connectors.api_version
    kind        = confluent_service_account.connectors.kind
  }
  managed_resource {
    id          = confluent_kafka_cluster.cc_kafka_cluster.id
    api_version = confluent_kafka_cluster.cc_kafka_cluster.api_version
    kind        = confluent_kafka_cluster.cc_kafka_cluster.kind
    environment {
      id = confluent_environment.cc_demo_env.id
    }
  }
  depends_on = [
    confluent_kafka_acl.connectors_source_create_topic_demo,
    confluent_kafka_acl.connectors_source_write_topic_demo,
    confluent_kafka_acl.connectors_source_read_topic_demo,
    confluent_kafka_acl.connectors_source_create_topic_dlq,
    confluent_kafka_acl.connectors_source_write_topic_dlq,
    confluent_kafka_acl.connectors_source_read_topic_dlq,
    confluent_kafka_acl.connectors_source_consumer_group,
  ]
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Create Kafka topics for the DataGen Source Connector
# --------------------------------------------------------
resource "confluent_kafka_topic" "credit_card" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  topic_name       = "demo-credit-card"
  partitions_count = 1
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Create Kafka topics for the Oracle CDC Source Connector
# --------------------------------------------------------
resource "confluent_kafka_topic" "oracle_cdc_redo_log" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  topic_name       = "demo-OracleCdcSourceConnector-dbmod-redo-log"
  partitions_count = 1
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clients_kafka_cluster_key.id
    secret = confluent_api_key.clients_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Connectors
# --------------------------------------------------------
# datagen_credit_card
resource "confluent_connector" "datagen_credit_card" {
  environment {
    id = confluent_environment.cc_demo_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  config_sensitive = {}
  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "datagen_source_credit_card"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.connectors.id
    "kafka.topic"              = confluent_kafka_topic.credit_card.topic_name
    "output.data.format"       = "AVRO"
    "schema.string"            = data.external.env_vars.result.CREDIT_CARD_SCHEMA
    "schema.keyfield"          = "user_id"
    "tasks.max"                = "1"
    "max.interval"             = "1000"
  }
  depends_on = [
    confluent_kafka_acl.connectors_source_create_topic_demo,
    confluent_kafka_acl.connectors_source_write_topic_demo,
    confluent_kafka_acl.connectors_source_read_topic_demo,
    confluent_kafka_acl.connectors_source_create_topic_dlq,
    confluent_kafka_acl.connectors_source_write_topic_dlq,
    confluent_kafka_acl.connectors_source_read_topic_dlq,
    confluent_kafka_acl.connectors_source_consumer_group,
  ]
  lifecycle {
    prevent_destroy = false
  }
}
output "datagen_credit_card" {
  description = "CC Datagen Credit Card Connector ID"
  value       = resource.confluent_connector.datagen_credit_card.id
}

# Oracle CDC Source
resource "confluent_connector" "oracle_cdc_source" {
  environment {
    id = confluent_environment.cc_demo_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  config_sensitive = {
    "oracle.password": var.rds_password
  }
  config_nonsensitive = {
    "connector.class": "OracleCdcSource",
    "name": "oracle_cdc_source",
    "kafka.auth.mode": "SERVICE_ACCOUNT"
    "kafka.service.account.id": confluent_service_account.connectors.id
    "oracle.server": "${aws_db_instance.default.address}",
    "oracle.port": "1521",
    "oracle.sid": "ORCL",
    "oracle.username": var.rds_username,
    "table.inclusion.regex": "ORCL[.]ADMIN[.]CUSTOMERS",
    "start.from": "snapshot",
    "query.timeout.ms": "60000",
    "redo.log.row.fetch.size": "1",
    "table.topic.name.template": "demo-$${databaseName}.$${schemaName}.$${tableName}",
    "lob.topic.name.template": "demo-$${databaseName}.$${schemaName}.$${tableName}.$${columnName}",
    "redo.log.topic.name": confluent_kafka_topic.oracle_cdc_redo_log.topic_name,
    "enable.large.lob.object.support": "true",
    "numeric.mapping": "best_fit_or_double",
    "output.data.key.format": "JSON",
    "output.data.value.format": "JSON_SR",
    "transforms": "DoB_Mask",
    "transforms.DoB_Mask.type": "org.apache.kafka.connect.transforms.MaskField$Value",
    "transforms.DoB_Mask.fields": "DOB",
    "transforms.DoB_Mask.replacement": "<xxxx-xx-xx>",
    "tasks.max": "1"
  }
  depends_on = [
    confluent_kafka_acl.connectors_source_create_topic_demo,
    confluent_kafka_acl.connectors_source_write_topic_demo,
    confluent_kafka_acl.connectors_source_read_topic_demo,
    confluent_kafka_acl.connectors_source_create_topic_dlq,
    confluent_kafka_acl.connectors_source_write_topic_dlq,
    confluent_kafka_acl.connectors_source_read_topic_dlq,
    confluent_kafka_acl.connectors_source_consumer_group,
    confluent_kafka_acl.cdc_source_consumer_group,
    confluent_kafka_topic.oracle_cdc_redo_log,
    aws_db_instance.default,
  ]
  lifecycle {
    prevent_destroy = false
  }
}
output "oracle_cdc_source" {
  description = "CC Oracle CDC Source Connector ID"
  value       = resource.confluent_connector.oracle_cdc_source.id
}