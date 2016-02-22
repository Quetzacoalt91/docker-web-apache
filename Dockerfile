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
    && docker-php-ext-install iconv mcrypt pdo pdo_mysql mbstring soap gd zip

# Apache configuration
RUN a2enmod rewrite
RUN a2enmod ssl
RUN chown www-data:www-data -R /var/www/html/

# PHP configuration
COPY config_files/php.ini /usr/local/etc/php/
COPY apache-start.sh /usr/local/bin/

CMD ["apache-start.sh"]

