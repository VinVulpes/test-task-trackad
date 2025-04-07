FROM php:8.2-fpm-alpine 
# можно добавить проксирование образа

WORKDIR /var/www/html

# Создание пользователя и группы для безопасного запуска
RUN addgroup -S symfony && adduser -S symfony -G symfony

# Установка зависимостей + инструментов для сборки PECL-расширений
RUN apk add --no-cache \
        git \
        unzip \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        icu-dev \
        libzip-dev \
        postgresql-dev \
        autoconf \
        gcc \
        g++ \
        make \
        linux-headers

# Установка и активация Redis
RUN pecl install redis \
    && docker-php-ext-enable redis

# Установка PHP-расширений
RUN docker-php-ext-install -j$(nproc) sockets gd intl zip pdo pdo_pgsql opcache

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копирование зависимостей и установка
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Копирование кода приложения
COPY . .

# Оптимизация Symfony
RUN bin/console cache:warmup

# Настройка прав доступа
RUN chown -R symfony:symfony /var/www/html

# Переключение на безопасного пользователя
USER symfony

# Открытие порта и запуск контейнера
EXPOSE 9000
CMD ["php-fpm"]
