#!/bin/sh

# vsftpd'nin güvenli chroot dizini `/var/run` içinde oluşturulmazsa giriş işlemi çöküyor (OOPS hatası)
mkdir -p /var/run/vsftpd/empty

# Varsayılan olarak Debian vsftpd IPv6'yı dinler ve IPv4 bağlantılarını reddedebilir, bunu düzeltelim:
sed -i "s/listen_ipv6=YES/listen_ipv6=NO/g" /etc/vsftpd.conf
sed -i "s/listen=NO/listen=YES/g" /etc/vsftpd.conf
# Eğer listen=NO yoksa diye listen=YES satırını her ihtimale karşı ekle
grep -q "^listen=YES" /etc/vsftpd.conf || echo "listen=YES" >> /etc/vsftpd.conf

# Kullanıcı daha önce oluşturulmadıysa oluştur
if ! id -u "$FTP_USER" >/dev/null 2>&1; then
    # FTP_USER adında bir Linux kullanıcısı oluştur
    useradd -m -s /bin/bash "$FTP_USER"
    
    # Şifresini .env'den gelen FTP_PASSWORD olarak belirle
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

    # Kullanıcının FTP ile girdiğinde göreceği ana klasörü WordPress klasörü yap
    usermod -d /var/www/html "$FTP_USER"
    
    # Klasör sahipliğini bu kullanıcıya ver ki dosya yükleyip silebilsin
    chown -R $FTP_USER:$FTP_USER /var/www/html
    
    # vsftpd kullanıcı listesine bu kullanıcıyı ekle
    echo "$FTP_USER" | tee -a /etc/vsftpd.userlist
fi

# FTP sunucusunu (vsftpd) ön planda başlat (Konteynerin açık kalması için)
exec vsftpd /etc/vsftpd.conf