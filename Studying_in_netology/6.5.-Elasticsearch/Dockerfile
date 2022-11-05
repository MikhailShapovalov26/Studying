FROM centos:7

WORKDIR /usr/elastic

RUN yum update -y 1>/dev/null \
    && yum -y install wget curl vim perl default-jre 1>/dev/null \
    && wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.2-linux-x86_64.tar.gz \
    && tar -xzf elasticsearch-8.2.2-linux-x86_64.tar.gz 1>/dev/null 
RUN groupadd elasticsearch && useradd elasticsearch -g elasticsearch -p elasticsearch \
    && chown -R elasticsearch:elasticsearch /usr/elastic \
    && chmod o+x /root/ /usr/elastic \
    && chgrp elasticsearch /usr/elastic 
#RUN cd elasticsearch-8.2.2/
RUN mkdir /var/log/elasticsearch && mkdir /var/lib/elasticsearch/ 
RUN chown -R elasticsearch:elasticsearch /var/lib/elasticsearch && chown -R elasticsearch:elasticsearch /var/log/elasticsearch \
    && chmod o+x /root/ /var/lib/elasticsearch && chmod o+x /root/ /var/log/elasticsearch \
    && chgrp elasticsearch /var/lib/elasticsearch && chgrp elasticsearch /var/log/elasticsearch
EXPOSE 9200
EXPOSE 9300
USER elasticsearch
CMD ["/usr/elastic/elasticsearch-8.2.2/bin/elasticsearch"]
#ENTRYPOINT ["sleep", "infinity" ]
