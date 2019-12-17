{
  "path.data": "/var/lib/elasticsearch/data",
  "path.logs": "/var/lib/elasticsearch/logs",

  "cluster.initial_master_nodes": "${initial_master_ip}",
  "cluster.name": "${cluster_name}",
  "discovery.seed_hosts": "${internal_ip}",

  "node.data": true,
  "node.master": true,

  "network.host": "0.0.0.0",
  "http.port": 9200,
  "transport.port": 9300,

  "bootstrap.memory_lock": false,
  "action.auto_create_index": true,

  "xpack.security.enabled": "true",
  "xpack.security.transport.ssl.enabled": true,
  "xpack.security.audit.enabled": true,

  "xpack.security.transport.ssl.verification_mode": "certificate",
  "xpack.security.transport.ssl.key": "/etc/elasticsearch/client.key",
  "xpack.security.transport.ssl.certificate": "/etc/elasticsearch/client.pem",
  "xpack.security.transport.ssl.certificate_authorities": "/etc/elasticsearch/ca.pem"

}