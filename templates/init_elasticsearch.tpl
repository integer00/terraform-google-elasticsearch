
check_java_version() {
  yum install java-latest-openjdk
#register version

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
}
yum install elasticsearch

systemctl daemon-reload
systemctl enable elasticsearch.service

}
check_installation() {


}


check_java_version
check_installation