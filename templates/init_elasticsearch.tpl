#!/usr/bin/env sh
#Elasticsearch bootstrap script

set -e

check_java_version() {
  yum -q -y install java-latest-openjdk
#register version

}

install_elasticsearch() {

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF


yum -q -y install elasticsearch

systemctl -q daemon-reload
systemctl -q enable elasticsearch.service

}

check_installation() {

echo "get config"
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/es_config -o /etc/elasticsearch/elasticsearch.yml
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/es_jvm_options -o /etc/elasticsearch/jvm.options

echo "get ca"
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/es_ssl_ca -o /etc/elasticsearch/ca.pem

echo "get key"
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/es_ssl_key -o /etc/elasticsearch/client.key

echo "get crt"
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/es_ssl_crt -o /etc/elasticsearch/client.pem

}

start_es(){
  systemctl -q start elasticsearch.service
}

check_java_version
install_elasticsearch
check_installation
start_es

echo "done"