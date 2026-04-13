FROM debian:bullseye

RUN apt update && apt install -y \
    mariadb-server \
    php-fpm \
    php-mysql \
    unzip \
    curl \
    wget

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN wget https://wordpress.org/latest.tar.gz \
	&& tar -xzf latest.tar.gz \
	&& mv wordpress/* . \
	&& rm -rf wordpress latest.tar.gz

RUN mkdir -p /var/www/html /run/php

RUN sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 9000|g' \
	/etc/php/*/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
