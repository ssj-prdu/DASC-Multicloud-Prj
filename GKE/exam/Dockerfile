FROM php:8.2-apache
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN a2enmod rewrite
RUN echo "display_errors = On" >> /usr/local/etc/php/php.ini
COPY ./php /var/www/html/
RUN chown -R www-data:www-data /var/www/html/
EXPOSE 80 443