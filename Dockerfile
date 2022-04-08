FROM php:7.4-fpm

# Argumentos definidos em docker-compose.yml
ARG user
ARG uid

# Instale dependências do sistema
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libxml2-dev \
    libbz2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    build-essential \
    mariadb-client \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    libzip-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libxml++2.6-dev

# Limpar cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instale extensões PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets xml zip

# Obtenha o compositor mais recente
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crie um usuário do sistema para executar os comandos Composer e Artisan
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Instalar redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Definir diretório de trabalho
WORKDIR /var/www

USER $user
