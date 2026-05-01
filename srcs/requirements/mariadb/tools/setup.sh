#!/bin/bash
set -e

echo ">>> MariaDB hazırlanıyor..."

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo ">>> MariaDB data dizini initialize ediliyor..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

echo ">>> MariaDB geçici modda başlatılıyor (bootstrap)..."
mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
pid="$!"

echo ">>> MariaDB hazır olana kadar bekleniyor..."
until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent 2>/dev/null; do
    sleep 1
done

echo ">>> Kullanıcılar ve yetkiler ayarlanıyor..."
mysql --protocol=socket -uroot --socket=/run/mysqld/mysqld.sock <<EOF                                                                                                
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';                                                                                                
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;                                                                                                                 
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';                                                                                              
FLUSH PRIVILEGES;                                                                                                                                                    
EOF

echo ">>> Geçici MariaDB kapatılıyor..."
mysqladmin --protocol=socket -u root -p"${MYSQL_ROOT_PASSWORD}" --socket=/run/mysqld/mysqld.sock shutdown
wait "$pid" || true

echo ">>> MariaDB normal modda başlatılıyor..."
exec mysqld --user=mysql --bind-address=0.0.0.0 --port=3306