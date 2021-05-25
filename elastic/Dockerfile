FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.6.2 

ARG VULNIQ_CUSTOMER_ACCESS_TOKEN

COPY jvm.options /usr/share/elasticsearch/config/jvm.options
COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

RUN mkdir /vulniq \
    && cd /vulniq \
    && wget --header="Authorization: Bearer $VULNIQ_CUSTOMER_ACCESS_TOKEN" https://license.vulniq.com/download/elastic-schema-create.sh


# AFTER THE CONTAINER STARTS, run "docker exec -it vulniq_pro_elastic_1 /bin/bash" and run the following command in the container
#    /vulniq/elastic-schema-create.sh
# this will create the elasticsearch schema used by VulnIQ
