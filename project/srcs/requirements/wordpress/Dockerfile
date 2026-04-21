FROM debian:bullseye

RUN apt update && apt install -y \
    php7.4-fpm \
    php7.4-mysql \
    php-redis \
    unzip \
    curl \
    wget \
    default-mysql-client

# PHP ve web kök dizinlerini oluştur
RUN mkdir -p /var/www/html /run/php

WORKDIR /var/www/html

# WP-CLI indir ve kur
# WordPress'i tarayıcıya (arayüze) ihtiyaç duymadan, direkt komut satırından (terminalden) kurmamızı ve yönetmemizi sağlar.
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# WordPress dosyalarını indir
RUN wp core download --allow-root --path=/var/www/html

# PHP-FPM'i 9000 portuna ayarla (socket yerine TCP)
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' \
    /etc/php/7.4/fpm/pool.d/www.conf

# NGINX başka container'dan bağlanacağı için (TCP) allowed_clients kısıtını kaldır
# Normalde PHP kendi içinde bir dosya üzerinden haberleşir (socket). Ancak bizim mimarimizde Nginx ayrı bir konteynerde olduğu için, PHP'nin dışarıdan gelen bağlantıları dinlemesi gerekir. sed komutlarıyla PHP'nin 9000 portunu dinlemesi sağlanır ve IP kısıtlamaları kaldırılır.
RUN sed -i 's|^listen.allowed_clients = 127.0.0.1|;listen.allowed_clients = 127.0.0.1|g' \
    /etc/php/7.4/fpm/pool.d/www.conf

# www-data kullanıcısının /var/www/html'e yazmasına izin ver
RUN chown -R www-data:www-data /var/www/html

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 9000

CMD ["/setup.sh"]