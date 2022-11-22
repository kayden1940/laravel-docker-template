FROM php:fpm-buster
# FROM php:7.4-fpm-buster

COPY ./docker/php/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html


# FIXME: 余計なものをインストールしてる可能性アリ
RUN apt-get update
RUN apt-get install -y \
  git \
  zip \
  unzip \
  vim \
  curl \
  libz-dev \
  libzip-dev \
  libjpeg-dev \
  libfreetype6-dev \
  libssl-dev \
  libmcrypt-dev \
  nano

RUN docker-php-ext-install \
  pdo_mysql \
  mysqli  \
  zip \
  gd \
  iconv \
  exif

# node.js
# RUN apt-get install -y nodejs npm
# RUN npm install n -g 
# RUN n 14.16.0

# composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
# COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
