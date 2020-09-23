FROM centos:7
MAINTAINER Myh muyahid.sassantiwong@global.ntt
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum clean all; yum makecache
RUN yum update -y
RUN yum install git java-1.8.0-openjdk java-1.8.0-openjdk-devel -y
RUN echo export JAVA_HOME=/usr/lib/jvm/jre-1.8.0 >>/etc/profile
RUN source /etc/profile
COPY elasticsearch.repo /etc/yum.repos.d/
COPY kibana.repo /etc/yum.repos.d/
COPY logstash.repo /etc/yum.repos.d/
RUN yum install elasticsearch kibana logstash -y
RUN cd /opt && git clone https://github.com/myh-st/fping-es.git
RUN cd /opt && git clone https://github.com/myh-st/ssh-es.git
RUN cp /opt/fping-es/logstash/conf.d/fping2es.conf /etc/logstash/conf.d/
# RUN rpm -ivh https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.1-x86_64.rpm
# RUN rpm -ivh https://artifacts.elastic.co/downloads/logstash/logstash-7.9.1.rpm
# RUN rpm -ivh https://artifacts.elastic.co/downloads/kibana/kibana-7.9.1-x86_64.rpm
# RUN rpm -ivh https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-7.9.1-x86_64.rpm
# RUN systemctl start heartbeat-elastic && systemctl enable heartbeat-elastic
# RUN systemctl start elasticsearch && systemctl enable elasticsearch
# RUN systemctl start logstash && systemctl enable logstash
# RUN systemctl start kibana && systemctl enable kibana
COPY kibana.yml /etc/kibana/kibana.yml
COPY elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
# COPY logstash.yml /etc/logstash/logstash.yml
#COPY start-elk.sh /etc/init.d
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-7.9.1-x86_64.rpm
RUN rpm -vi heartbeat-7.9.1-x86_64.rpm
# RUN heartbeat setup
VOLUME [ "/var/lib/elasticsearch", "/opt/ssh-es", "/opt/fping-es" ]
#CMD [ "/etc/init.d/start-elk.sh" ]
# RUN heartbeat setup
EXPOSE 5601 9200 9300 9600 5044
