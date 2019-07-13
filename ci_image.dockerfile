#first stage build for installing composer
FROM composer:1.5.1 AS composer

FROM php:7.2

# Copy Composer executable from the first stage build into the next build
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Environment variables
ENV COMPOSER_ALLOW_SUPERUSER 1 
ENV DOCKERIZE_VERSION v0.6.1

RUN apt update && \
   apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
   curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
   add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
   apt update && \
   apt install -y docker-ce && \
   echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
   curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
   apt-get update && \
   apt-get install -y kubectl google-cloud-sdk && \
   apt-get update && \
   echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee /etc/apt/sources.list.d/ansible.list && \
   echo "deb-src http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/ansible.list && \
   apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
   apt-get update -y && \
   apt-get install ansible -y && \
   apt update -y && \
   apt install python3-pip -y && \
   pip3 install openshift && pip3 install kubernetes

RUN apt-get update && apt-get install -y wget && \ 
   wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
   && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
   && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
   && apt install libpq-dev zlib1g-dev libsqlite3-dev -y \
   && docker-php-ext-install bcmath pcntl pdo_pgsql pgsql \
   && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
   && apt-get update && apt-get install -y zip unzip \
   && pecl install xdebug && docker-php-ext-enable xdebug
