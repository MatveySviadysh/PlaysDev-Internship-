FROM php:8.0-apache

RUN apt-get update && \
    apt-get install -y libpng-dev && \
    docker-php-ext-install gd

COPY html/info.php /var/www/html/
RUN chmod -R 755 /var/www/html && chown -R www-data:www-data

COPY apache2.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]
