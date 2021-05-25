FROM ubuntu:18.04
ARG VULNIQ_CUSTOMER_ACCESS_TOKEN

RUN apt-get clean && apt-get --fix-missing update
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y apt-utils ntp curl  gnupg apache2 wget libgconf-2-4

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && apt-get install -y nodejs

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable libnss3-tools


RUN npm install express && npm install puppeteer && npm install sharp && npm install simple-node-logger --save && npm install uuid

RUN mkdir /vulniq \
    && cd /vulniq \
    && wget --header="Authorization: Bearer $VULNIQ_CUSTOMER_ACCESS_TOKEN" https://license.vulniq.com/download/vulniq-webpage-renderer.js


WORKDIR /vulniq
CMD node vulniq-webpage-renderer.js