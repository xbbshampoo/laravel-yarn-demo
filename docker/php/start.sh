#!/bin/bash

# Prep-up Laravel Caching
php /app/artisan config:cache
php /app/artisan route:cache
php /app/artisan queue:restart

# START SUPERVISOR.
exec php-fpm
