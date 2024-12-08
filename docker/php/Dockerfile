ARG PHP_IMAGE_VERSION=8.2-fpm
# ARG COMPOSER_VERSION=2.5.5

FROM php:${PHP_IMAGE_VERSION}
EXPOSE 5173

ENV COMPOSER_VERSION=2.5.5
ENV NODE_VERSION=18.17.1

COPY ./docker/php/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html


# FIXME: 余計なものをインストールしてる可能性アリ
RUN apt-get update && apt-get install -y \
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
  exif \
  bcmath

RUN pecl install xdebug && docker-php-ext-enable xdebug

# composer
# COPY --from=composer:${COMPOSER_VERSION} /usr/bin/composer /usr/bin/composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
  && php -r "unlink('composer-setup.php');"

# node.js
RUN apt-get install -y nodejs npm
RUN npm install n -g 
RUN n ${NODE_VERSION}

WORKDIR /var/www/html
