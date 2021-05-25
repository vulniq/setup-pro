FROM php:7.4-apache-buster
SHELL ["/bin/bash", "-c"]

ARG VULNIQ_CUSTOMER_ACCESS_TOKEN
ARG VULNIQ_BUILD_DATE

RUN apt update  \
    && apt-get -y install gnupg apt-transport-https lsb-release ca-certificates curl wget \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
    && apt-get update


RUN apt-get update && apt-get install -y  libmemcached-dev libmemcached11 zlib1g-dev libzip-dev unzip

#TODO install via apt
RUN docker-php-ext-install pdo_mysql

RUN pecl install memcached && docker-php-ext-enable memcached

COPY ./webapp/apache-privatekey.key /etc/ssl/private/
COPY ./webapp/apache-certificate.crt /etc/ssl/certs/
COPY ./webapp/apache-site-engine.conf ./webapp/apache-site-reporting-app.conf /etc/apache2/sites-available/
COPY ./webapp/apache-overrides.conf /etc/apache2/conf-available/zzzzz-apache-overrides.conf
COPY ./webapp/php.ini /usr/local/etc/php/php.ini


RUN a2enmod rewrite \
    && a2enmod headers \
    && a2enmod ssl \
    && a2ensite apache-site-engine \
    && a2ensite apache-site-reporting-app \
    && a2enconf zzzzz-apache-overrides


RUN mkdir /vulniq \
    && mkdir /vulniq/frontend \
    && cd /vulniq/frontend/ \
    && wget -O VulnIQFrontend.zip --header="Authorization: Bearer $VULNIQ_CUSTOMER_ACCESS_TOKEN" "https://license.vulniq.com/download/VulnIQFrontend.zip?date=$VULNIQ_BUILD_DATE" \
    && unzip VulnIQFrontend.zip

COPY ./vulniq.license /vulniq/frontend/php-lib/
