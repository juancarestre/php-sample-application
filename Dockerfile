# Stage 1: Build Stage
FROM php:7.4-apache AS build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        make \
        wget \
        curl \
        git

WORKDIR /var/www/html

COPY composer.json ./

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev

COPY . .

# Stage 2: Production Stage
FROM php:7.4-apache

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        mariadb-client && \
        apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql

COPY --from=build /var/www/html /var/www/html

RUN chown -R www-data:www-data /var/www/html

RUN a2enmod rewrite

COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

RUN a2ensite 000-default.conf && \
    service apache2 restart

EXPOSE 80

CMD ["apache2-foreground"]
