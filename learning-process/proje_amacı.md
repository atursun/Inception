Projenin amacı;

**3 temel servis:**

1. **NGINX** — Tek giriş noktası (port 443, TLS ile)
2. **WordPress + php-fpm** — Web uygulaması
3. **MariaDB** — Veritabanı

Ve bunları birbirine bağlayan bir **Docker network**, verilerin kaybolmaması için de **2 adet named volume** (biri WordPress dosyaları, biri veritabanı için).

Yani mimari şöyle akar:

```
Kullanıcı → NGINX (443) → WordPress → MariaDB
```

Her servis kendi container'ında izole çalışıyor, ama aynı network üzerinden birbirini görebiliyor. Temel fikir bu kadar basit aslında — geri kalan her şey (Dockerfile yazmak, .env, secrets, Makefile) bu üç servisin doğru kurulması için gereken altyapı.
