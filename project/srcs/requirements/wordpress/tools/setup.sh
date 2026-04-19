#!/bin/bash
set -e

echo ">>> MariaDB bekleniyor..."
until mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent 2>/dev/null; do
    sleep 2
done
echo ">>> MariaDB hazır!"
    
# wp-config.php kontrolünü doğru path'te yap
if [ ! -f /var/www/html/wp-config.php ]; then
    echo ">>> WordPress yapılandırılıyor..."

    wp config create --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --path='/var/www/html'

    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path='/var/www/html'

    wp user create --allow-root \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASS}" \
        --path='/var/www/html'

    echo ">>> Redis yapılandırılıyor ve etkinleştiriliyor..."
    wp config set WP_CACHE true --raw --type=constant --allow-root --path='/var/www/html'
    wp config set WP_REDIS_HOST 'redis' --type=constant --allow-root --path='/var/www/html'
    wp config set WP_REDIS_PORT 6379 --raw --type=constant --allow-root --path='/var/www/html'
    
    wp plugin install redis-cache --activate --allow-root --path='/var/www/html'
    wp redis enable --allow-root --path='/var/www/html'

    echo ">>> WordPress kurulumu tamamlandı!"
else
    echo ">>> WordPress zaten kurulu, atlanıyor."
fi

mkdir -p /run/php

echo ">>> PHP-FPM başlatılıyor..."
exec php-fpm7.4 -F