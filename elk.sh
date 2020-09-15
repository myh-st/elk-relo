#!/bin/bash
#Install ELK 7.x
if [[ ! -e /usr/bin/java ]]; then
	yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel -y
	echo export JAVA_HOME=/usr/lib/jvm/jre-1.8.0 >>/etc/profile
	source /etc/profile
fi
if [[ ! -e /usr/share/elasticsearch/bin/elasticsearch ]]; then
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
	cat <<EOF >/etc/yum.repos.d/elasticsearch.repo
		[elasticsearch-7.x]
		name=Elasticsearch repository for 7.x packages
		baseurl=https://artifacts.elastic.co/packages/7.x/yum
		gpgcheck=1
		gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
		enabled=1
		autorefresh=1
		type=rpm-md
EOF
	yum install elasticsearch -y
fi
if [[ ! -e /usr/share/kibana/bin/kibana ]]; then
	cat <<EOF >/etc/yum.repos.d/kibana.repo
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
	yum install kibana -y
	sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/g' /etc/kibana/kibana.yml
fi
if [[ ! -e /usr/share/logstash/bin/logstash ]]; then
	cat <<EOF >/etc/yum.repos.d/logstash.repo
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
	yum install logstash -y
fi
if [[ -e /etc/sysconfig/iptables ]]; then
	CHECK_PORT=$(grep "5601" /etc/sysconfig/iptables | wc -l)
	if [[ $CHECK_PORT -gt 0 ]]; then
	sed -i '/-A INPUT -i lo -j ACCEPT/a -A INPUT -p tcp -m state --state NEW -m tcp --dport 5601 -j ACCEPT' /etc/sysconfig/iptables
	fi
	/sbin/service iptables status >/dev/null 2>&1
	if [ $? = 0 ]; then
	    service iptables restart
	fi
	# service iptables restart
fi
# systemctl start kibana && systemctl enable kibana.service
service kibana restart && chkconfig kibana on
# systemctl start elasticsearch && systemctl enable elasticsearch.service
service elasticsearch restart && chkconfig elasticsearch on
