# elk-relo
elk stack for relocation

ELK Version 7.9.1

# Clone relo-tools
git clone https://github.com/myh-st/fping-es.git /opt/fping-es

git clone https://github.com/myh-st/ssh-es.git /opt/sh-es

# Run Container
docker run -dit --restart=always --hostname elk-relo -p 9200:9200 -p 9300:9300 -p 5044:5044 -p 9600:9600 -p 5601:5601 -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /opt/ssh-es:/opt/ssh-es -v /opt/fping-es:/opt/fping-es  --name elk-relo muyahid/elk-relo /usr/sbin/init
