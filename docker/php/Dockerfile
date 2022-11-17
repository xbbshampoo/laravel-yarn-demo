# syntax=docker/dockerfile:1
# =====================================================================================================================
FROM node:18-alpine as yarn-production

# setup basic WORK DIRECTORY
WORKDIR /app

# copy app
COPY . /app

# install required packages for yarn && building javascript assets command
RUN yarn install && yarn build
# =====================================================================================================================

# =====================================================================================================================
FROM php:8.1-fpm as php-base

ARG APP_USER=1000
ARG APP_GROUP=1000
ARG CURRENT_ENVIRONMENT=production

# setup basic WORK DIRECTORY
WORKDIR /app

# Install unzip utility and libs needed by zip PHP extension
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip

# install some base extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    IPE_GD_WITHOUTAVIF=1 install-php-extensions zip pdo_mysql pdo_pgsql bcmath gd

# install Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# copy base php configuration
RUN mv "$PHP_INI_DIR/php.ini-$CURRENT_ENVIRONMENT" "$PHP_INI_DIR/php.ini"

COPY docker/php/laravel-app-"$CURRENT_ENVIRONMENT".ini "$PHP_INI_DIR/conf.d/laravel-app.ini"

# Re-setup permissions
RUN find / -not -path "*/proc/*" -group www-data -exec chgrp -h ${APP_GROUP} {} \;
RUN find / -not -path "*/proc/*" -user www-data -exec chown -h ${APP_USER} {} \;
RUN usermod -u "${APP_USER}" www-data && groupmod -g "${APP_GROUP}" www-data

# copy app
COPY --chown=www-data:www-data . /app

# create empty folder for vendor, setup folder permissions and render start.sh executable
RUN mkdir vendor && \
	chown -R www-data:www-data vendor && \
	chmod -R 755 /app/storage && \
	chmod +x /app/docker/php/start.sh
# =====================================================================================================================

# =====================================================================================================================
FROM php-base as php-development

# set default user when running exec into container
USER www-data
# =====================================================================================================================

# =====================================================================================================================
FROM php-base as php-production

# copy compiled assets from yarn-production stage into /app/public folder
COPY --from=yarn-production --chown=www-data:www-data /app/public /app/public

# set default user when running exec into container
USER www-data

RUN composer install --optimize-autoloader --no-dev

CMD ["./docker/php/start.sh"]
# =====================================================================================================================
