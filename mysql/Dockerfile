FROM mysql:8.0.20

ARG VULNIQ_CUSTOMER_ACCESS_TOKEN
ARG VULNIQ_BUILD_DATE

SHELL ["/bin/bash", "-c"]


RUN apt update  \
    && apt-get -y install wget 

RUN mkdir /vulniq \
    && cd /vulniq \
    && wget -O vulniq-db-schema.sql.gz --header="Authorization: Bearer $VULNIQ_CUSTOMER_ACCESS_TOKEN" https://license.vulniq.com/download/vulniq-db-schema.sql.gz?date=$VULNIQ_BUILD_DATE \
    && gunzip vulniq-db-schema.sql.gz

# FOR INITIAL INSTALLATIONS ONLY: AFTER THE CONTAINER STARTS, run create-mysql-schema.sh to create the database schema