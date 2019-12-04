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

echo "get meta"
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/es_config -o /etc/elasticsearch/elasticsearch.yml

}

start_es(){
  systemctl -q start elasticsearch.service
}

check_java_version
install_elasticsearch
check_installation
start_es

echo "done"