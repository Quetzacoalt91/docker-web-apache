FROM php:7-apache

MAINTAINER Thomas Nabord <thomas.nabord@prestashop.com

RUN apt-get update \
	&& apt-get install -y libmcrypt-dev \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libfreetype6-dev \
		libxml2-dev \
		wget \
		unzip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install iconv mcrypt pdo pdo_mysql mbstring soap gd

# Apache configuration
RUN a2enmod rewrite
RUN a2enmod ssl
RUN chown www-data:www-data -R /var/www/html/

# PHP configuration
COPY config_files/php.ini /usr/local/etc/php/
RUN mv /usr/local/etc/php/conf.d/docker-php-ext-pdo.ini /usr/local/etc/php/conf.d/docker-php-ext-pdo.ini.nope
RUN mv /usr/local/etc/php/conf.d/docker-php-ext-iconv.ini /usr/local/etc/php/conf.d/docker-php-ext-iconv.ini.nope

VOLUME /var/www/html

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]