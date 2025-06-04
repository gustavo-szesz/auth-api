FROM php:8.0-apache

# Instala dependências do sistema
RUN apt-get update && apt-get install -y unzip libzip-dev && docker-php-ext-install zip

# Instala o Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copia os arquivos da aplicação
COPY api/ /var/www/html/

# Copia o composer.json e composer.lock para instalar dependências na raiz do projeto
COPY api/composer.json /var/www/html/composer.json
COPY api/composer.lock /var/www/html/composer.lock

# Instala dependências do Composer
WORKDIR /var/www/html
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Ativa o mod_rewrite do Apache
RUN a2enmod rewrite

# Permite .htaccess sobrescrever configurações
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]