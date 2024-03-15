module "self_service_agent"{
    source = "Senora-dev/self-service-agent/aws"
    version = "~>1.0.0"
    port_kafka_topics = ["org_qbNsLmREusEhrMk5.runs"]
    port_kafka_bootstrap_servers = "b-3-public.publicclusterprod.t9rw6w.c1.kafka.eu-west-1.amazonaws.com:9196,b-1-public.publicclusterprod.t9rw6w.c1.kafka.eu-west-1.amazonaws.com:9196,b-2-public.publicclusterprod.t9rw6w.c1.kafka.eu-west-1.amazonaws.com:9196"
    port_kafka_consumer_group_id = "Senora"
}