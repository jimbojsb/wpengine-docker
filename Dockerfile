FROM phusion/baseimage:0.9.20
ENV COMPOSER_ALLOW_SUPERUSER 1
EXPOSE 80

CMD /usr/local/bin/bootstrap-web

RUN apt-add-repository -y ppa:ondrej/php \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install -qqy --no-install-recommends \
        git \
        php7.1-cli \
        php7.1-common \
        php7.1-fpm \
        php7.1-zip \
        php7.1-mbstring \
        php7.1-mysql \
        php7.1-imagick \
        php7.1-gd \
        php7.1-mcrypt \
        php7.1-curl \
        php7.1-xml \
        php7.1-pgsql \
        ca-certificates \
        nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY etc/.bashrc /root/.bashrc
COPY etc/php.ini /etc/php/7.1/fpm/php.ini
COPY etc/php.ini /etc/php/7.1/cli/php.ini
COPY etc/php-fpm.conf /etc/php/7.1/fpm/php-fpm.conf
COPY etc/nginx.conf /etc/nginx/sites-available/default

COPY bin/bootstrap-web.sh /usr/local/bin/bootstrap-web
COPY bin/runit-nginx.sh /usr/local/bin/runit-nginx
COPY bin/runit-phpfpm.sh /usr/local/bin/runit-phpfpm

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

RUN mkdir /www
WORKDIR /www