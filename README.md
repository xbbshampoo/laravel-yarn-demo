# Laravel Project

## Software needed to run this project

1. [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for Windows or Mac)
2. [Docker CE](https://docs.docker.com/engine/install/ubuntu/) (for Linux)

## Instructions on how to run this project

1. Copy the content .env.example and paste it into .env

2. Run docker compose command.
    ```
    docker compose up -d --build
    ```

3. Once everything is okay, run this command below to install Laravel dependencies.
    ```
    docker exec -it php bash;

    composer install;
   
    php artisan migrate;
    ```

4. You can visit https://laravel-docker-base.localtest.me to visit the site.

5. Additionally, you can test run the tests using this command as well.
    ```
    php artisan test;
    ```

6. To close the docker compose, please run this.
    ```
    docker compose down;
    ```

7. To run nodejs related stuff, you can use command below.
    ```
    docker compose run --rm yarn install;
   
    docker compose run --rm yarn dev;
   
    docker compose run --rm yarn build;
    ```

8. Docker Build Instructions
    ```
    docker build --no-cache --network host --file ./docker/php/Dockerfile --target php-production --build-arg CURRENT_ENVIRONMENT=production -t xbbshampoo/laravel-test-app:latest .;
    
    docker build --no-cache --network host --file ./docker/nginx/Dockerfile --target webserver-production -t xbbshampoo/laravel-test-nginx:latest .;
   
    docker push xbbshampoo/laravel-test-nginx:latest;

    docker push xbbshampoo/laravel-test-app:latest;
    ```
