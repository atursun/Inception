FROM debian:bullseye

RUN apt update && apt install -y \
    php \
    php-mysqli \
    wget

WORKDIR /var/www

RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O index.php

RUN chown -R root:root /var/www/index.php && chmod 755 /var/www/index.php

EXPOSE 85

CMD ["php", "-S", "0.0.0.0:85", "-t", "/var/www"]