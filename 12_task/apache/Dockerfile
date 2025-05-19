FROM php:8.0-apache

RUN docker-php-ext-install mysqli pdo pdo_mysql

COPY info.php /var/www/html/

EXPOSE 80

CMD ["apache2-foreground"]