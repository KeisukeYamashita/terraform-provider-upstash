# Not necessary if the topic belongs to an already created cluster.
resource "upstash_kafka_cluster" "exampleKafkaCluster" {
  cluster_name = "Terraform_Upstash_Cluster"
  region       = "eu-west-1"
  multizone    = false
}


resource "upstash_kafka_topic" "exampleKafkaTopic" {
  topic_name       = "TerraformTopic"
  partitions       = 1
  retention_time   = 625135
  retention_size   = 725124
  max_message_size = 829213
  cleanup_policy   = "delete"

  # Here, you can use the newly created kafka_cluster resource (above) named exampleKafkaCluster.
  # And use its ID so that the topic binds to it.

  # Alternatively, provide the ID of an already created cluster.
  cluster_id = resource.upstash_kafka_cluster.exampleKafkaCluster.cluster_id
}


resource "upstash_kafka_connector" "exampleKafkaConnector" {
  name       = var.connector_name
  cluster_id = upstash_kafka_cluster.exampleKafkaCluster.cluster_id
  properties = {
    "collection" : "user123",
    "connection.uri" : "mongodb+srv://test:test@cluster0.fohyg7p.mongodb.net/?retryWrites=true&w=majority",
    "connector.class" : "com.mongodb.kafka.connect.MongoSourceConnector",
    "database" : "myshinynewdb2",
    "topics" : "${upstash_kafka_topic.exampleKafkaTopic.topic_name}"
  }

  # OPTIONAL: change between restart-running-paused
  # running_state = "running"
}

