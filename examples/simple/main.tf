module "self_service_agent"{
    source = "Senora-dev/self-service-agent/aws"
    version = "~>1.0.0"
    port_kafka_topics = ["PORT_ORG_ID.runs"]
    port_kafka_bootstrap_servers = "kafka1:9096,kafka2:9096,kafka3:9096"
    port_kafka_consumer_group_id = "PORT_KAFKA_CONSUMER_GROUP_ID"
}
