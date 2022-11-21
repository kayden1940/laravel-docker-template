# FROM php:fpm-buster
FROM php:7.4-fpm-buster

COPY ./container/php/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html


RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get install -y libz-dev
RUN apt-get install -y libzip-dev
RUN apt-get install -y libjpeg-dev
# RUN apt-get install -y libpng12-dev
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libmcrypt-dev
RUN apt-get install -y nano

# RUN apt-get install -y dnsut

RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-install iconv
RUN docker-php-ext-install exif

RUN apt-get install -y nodejs npm
RUN npm install n -g 
RUN n 14.16.0

# COPY --from=composer:1 /usr/bin/composer /usr/bin/composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
