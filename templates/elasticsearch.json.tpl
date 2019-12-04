{
  "path.data": "/var/lib/elasticsearch/data",
  "path.logs": "/var/lib/elasticsearch/logs",

  "cluster.initial_master_nodes": "${initial_master_ip}",
  "cluster.name": "elastic-cluster",
  "discovery.seed_hosts": "${internal_ip}",

  "bootstrap.memory_lock": false,
  "http.port": 9200,
  "network.host": "0.0.0.0",
  "node.data": true,
  "node.master": true,
  "transport.port": 9300,
  "action.auto_create_index": true,
}