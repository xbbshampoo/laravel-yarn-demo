# syntax=docker/dockerfile:1
# =====================================================================================================================
FROM node:16-slim as node-builder

# setup basic WORK DIRECTORY
WORKDIR /app

COPY . .

RUN yarn install && yarn build
# =====================================================================================================================

# =====================================================================================================================
FROM nginxinc/nginx-unprivileged:stable-alpine as webserver-development

COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d/

# setup basic WORK DIRECTORY
WORKDIR /app

# copy app
COPY --chown=nginx:nginx ./public /app/public

USER nginx
# =====================================================================================================================

# =====================================================================================================================
FROM nginxinc/nginx-unprivileged:stable-alpine as webserver-production

COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d/

# setup basic WORK DIRECTORY
WORKDIR /app

COPY --from=node-builder --chown=nginx:nginx /app/public /app/public

RUN sed -i -r "s,php:9000,laravel-service.default:9000,g" /etc/nginx/conf.d/default.conf

USER nginx
# =====================================================================================================================
