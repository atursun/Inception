  # Inception (Dockerized WordPress Stack)

Bu repo, Docker Compose ile **NGINX (TLS) + WordPress (PHP-FPM) + MariaDB** servislerinden oluşan küçük bir web altyapısı kurar. Amaç, servisleri ayrı container’larda izole şekilde çalıştırmayı; network/volume/TLS gibi “production’a yakın” altyapı kavramlarını öğrenmektir.

---

### İçindekiler

- [1. Proje Genel Analizi](#1-proje-genel-analizi)
- [2. Mimari ve Yapı](#2-mimari-ve-yapı)
- [3. Adım Adım Nasıl Çalışır](#3-adım-adım-nasıl-çalışır)
- [4. Kurulum ve Geliştirme Süreci](#4-kurulum-ve-geliştirme-süreci)
- [5. Kritik Detaylar (İnce Noktalar)](#5-kritik-detaylar-ince-noktalar)
- [6. Olası Hatalar ve Senaryolar (Debug)](#6-olası-hatalar-ve-senaryolar-debug)
- [7. Geliştirme ve İyileştirme Önerileri](#7-geliştirme-ve-iyileştirme-önerileri)
- [8. Gerçek Hayat Senaryosu (Production/DevOps)](#8-gerçek-hayat-senaryosu-productiondevops)

---

## 1. PROJE GENEL ANALİZİ

### Proje ne yapıyor?
Bu proje, 3 container’lık klasik bir WordPress altyapısını ayağa kaldırır:

- **`nginx`**: Dış dünyaya açılan tek giriş noktasıdır. **HTTPS 443** dinler, TLS terminasyonu yapar.
- **`wordpress`**: WordPress + **PHP-FPM** içerir. NGINX’ten gelen FastCGI isteklerini **9000** portunda alır.
- **`mariadb`**: WordPress’in kalıcı verisini tutar. İç ağda **3306** portunda dinler.

### Temel amacı nedir?
- Docker ile “çok servisli” bir sistemi **deklaratif** şekilde kurmak (Compose).
- Her servisi ayrı image/container ile **izole** etmek.
- **TLS**, özel network, kalıcı volume gibi konuları “gerçekçi” bir mini altyapı üzerinde öğrenmek.

### Hangi problemi çözüyor?
- Kurulum/bağımlılık/versiyon uyumsuzluğu problemlerini azaltır.
- Servis çakışmalarını (port, kütüphane sürümü, config) önler.
- Tek komutla aynı stack’i farklı ortamlarda çalıştırabilmeyi sağlar.

### Gerçek hayatta nasıl kullanılır?
- Küçük ölçekli WordPress siteleri için “tek sunucu” mimarisinin temelini simüle eder.
- Staging/demo ortamı olarak kullanılabilir (production için ekstra hardening gerekir).

---

## 2. MİMARİ VE YAPI

### Genel mimari
Bu proje, **reverse proxy + uygulama + veritabanı** mimarisidir:

1) Kullanıcı `https://...` ile gelir  
2) Trafik host üzerinden **`nginx:443`** container’ına gider  
3) NGINX statik dosyaları servis eder, `.php` isteklerini **FastCGI** ile **`wordpress:9000`**’a yollar  
4) WordPress gerektiğinde **`mariadb:3306`**’a bağlanır  
5) Yanıt geri döner: WordPress → NGINX → kullanıcı

### Kullanılan teknolojiler ve nedenleri
- **Docker + Docker Compose**: çok servisi tek dosyada yönetme, network/volume ile doğru izolasyon.
- **Debian bullseye**: stabil taban imaj, geniş paket deposu.
- **NGINX**: TLS terminasyonu + reverse proxy için standart.
- **PHP-FPM**: NGINX ile PHP yürütmesini doğru şekilde ayırır.
- **MariaDB**: WordPress için tipik, MySQL uyumlu veritabanı.
- **WP-CLI**: WordPress kurulumunu otomatik ve idempotent hale getirmek için.

### Servisler arası iletişim
`docker-compose.yml` içinde tek bir özel network var:

- **Network**: `inception` (bridge)
- Container’lar birbirini **servis adı** ile bulur:
  - NGINX → `fastcgi_pass wordpress:9000`
  - WordPress → DB host: `mariadb`

Portlar:
- Dışa açık: **443 → NGINX**
- İç ağ: **9000 (PHP-FPM)**, **3306 (DB)**

### Dosya yapısı (özet)
- `project/srcs/docker-compose.yml`: mimari/topoloji merkezi
- `project/srcs/requirements/<service>/Dockerfile`: servis image tarifleri
- `project/srcs/requirements/<service>/conf/*`: konfigürasyonlar
- `project/srcs/requirements/<service>/tools/setup.sh`: ilk kurulum/bootstrapping

---

## 3. ADIM ADIM NASIL ÇALIŞIR

### Image build aşaması

#### NGINX image
- `nginx` + `openssl` kurulur
- Build sırasında **self-signed sertifika** üretilir
- `nginx.conf` kopyalanır
- Container: `nginx -g "daemon off;"`

#### MariaDB image
- `mariadb-server` kurulur
- `mariadb.conf` kopyalanır
- Container CMD: `/setup.sh`

#### WordPress image
- PHP 7.4 FPM + mysql extension + wp-cli + mysql client kurulur
- Build sırasında `wp core download` ile WordPress dosyaları indirilir
- PHP-FPM socket yerine TCP **9000** dinleyecek şekilde ayarlanır
- Container CMD: `/setup.sh`

> **Not:** WordPress dosyaları build aşamasında image’a indirilir; runtime’da `/var/www/html` volume ile mount edildiği için ilk çalıştırmada volume “seed” davranışı önemlidir. Named volume ile genelde sorunsuzdur, bind-mount’a geçilirse farklı davranabilir.

### Container runtime aşaması
Compose sırası: `mariadb` → `wordpress` → `nginx`

#### MariaDB `setup.sh` (bootstrapping)
- Datadir yoksa initialize eder
- DB’yi geçici “bootstrap” modda (socket + skip-networking) açar
- Root şifresi, DB, user ve grant’ları idempotent şekilde uygular
- DB’yi normal modda `0.0.0.0:3306` bind ile başlatır

#### WordPress `setup.sh`
- DB hazır olana kadar bekler (`mysqladmin ping`)
- `wp-config.php` yoksa:
  - `wp config create`
  - `wp core install`
  - ek bir kullanıcı oluşturma
- PHP-FPM’i foreground başlatır: `php-fpm7.4 -F`

#### NGINX
- 443 TLS dinler
- `.php` isteklerini `wordpress:9000`’a FastCGI ile geçirir

---

## 4. KURULUM VE GELİŞTİRME SÜRECİ

### Gereksinimler
- Docker Engine
- Docker Compose v2

### Çalıştırma
Bu proje Compose içinde `env_file: .env` bekler. Repo `.env`’yi bilerek içermez (secret yönetimi).

1) `project/srcs/.env` dosyasını oluşturun.
2) Ardından:

```bash
cd project/srcs
docker compose up --build
```

### Beklenen ortam değişkenleri (önerilen set)
Scriptlerden ve compose’tan yola çıkarak tipik ihtiyaç:

- **DB**
  - `MYSQL_ROOT_PASSWORD`
  - `MYSQL_DATABASE`
  - `MYSQL_USER`
  - `MYSQL_PASSWORD`
- **WordPress**
  - `DOMAIN_NAME`
  - `WP_ADMIN_USER`
  - `WP_ADMIN_PASS`
  - `WP_ADMIN_EMAIL`
  - `WP_USER`
  - `WP_USER_PASS`
  - `WP_USER_EMAIL`

> Güvenlik için `.env` git’e eklenmemelidir.

### Geliştirici projeyi nasıl genişletir?
- Healthcheck ekleyerek servis bağımlılığını “ready” durumuna bağlamak
- NGINX tarafında güvenlik header’ları ve redirect kuralları
- WP-CLI ile tema/eklenti kurulum otomasyonu
- DB backup/restore akışı

---

## 5. KRİTİK DETAYLAR (İNCE NOKTALAR)

### `.env` ve secret hijyeni
- Compose `.env` bekliyor ancak repoda yok: bu doğru bir pratik.
- Kurulumu kolaylaştırmak için **`.env.example`** eklemek iyi olur (secret içermez, sadece şablon).

### NGINX domain/sertifika hardcode riski
- `server_name` ve sertifika CN’i hardcoded ise projeyi farklı domain ile taşımak zorlaşır.
- İdeal yaklaşım: domain’i env/build-arg ile parametrize etmek; sertifikayı SAN ile üretmek veya gerçek TLS (Let’s Encrypt).

### `depends_on` hazır olmayı garanti etmez
Compose’ta `depends_on` yalnızca başlatma sırasıdır; servis “ready” olmayabilir.
Bu repo, WordPress tarafında DB’yi bekleyerek bunu pratikte çözüyor; yine de daha sağlamı healthcheck’tir.

### WordPress DB bekleme kontrolünün auth’a bağlı olması
DB hazır olsa bile kullanıcı/şifre yanlışsa “bekliyor” gibi görünebilir. Bu en yaygın debug noktalarından biridir.

### Güvenlik
- Self-signed sertifika production için uygun değildir.
- NGINX security header’ları yok (HSTS/CSP vb. eklenebilir).
- MariaDB `0.0.0.0` bind: port publish edilmediği sürece dışa açık değildir; yanlış compose değişikliğiyle risk büyür.

---

## 6. OLASI HATALAR VE SENARYOLAR (DEBUG)

### Senaryo: `.env` yok / eksik
**Belirti**
- WordPress/MariaDB kurulum scriptleri boş env ile çalışır, kurulum bozulur.

**Çözüm**
- `project/srcs/.env` oluşturun ve tüm değişkenleri doldurun.

### Senaryo: WordPress “MariaDB bekleniyor…”da takılı kalır
**Olası nedenler**
- MariaDB container crash ediyor
- `MYSQL_USER/MYSQL_PASSWORD` yanlış
- MariaDB init/grant aşamasında hata
- network/DNS sorunu

**Debug**
- `docker logs mariadb`
- `docker logs wordpress`
- `docker ps` ile container health/durum kontrolü

### Senaryo: NGINX 502 Bad Gateway
**Olası nedenler**
- PHP-FPM 9000 dinlemiyor
- WordPress container down
- FastCGI upstream yanlış

**Debug**
- `docker logs nginx`
- `docker logs wordpress`

### Senaryo: WordPress “kurulu” görünüyor ama site bozuk
Kurulum kontrolü `wp-config.php` varlığına bağlı olduğu için “yarım kurulum” durumlarında tutarsız davranabilir.

**Çözüm**
- Development ortamında volume sıfırlama (dikkat: veri silinir)
- Daha sağlam idempotency: DB’de WP tablolarını kontrol ederek karar verme

---

## 7. GELİŞTİRME VE İYİLEŞTİRME ÖNERİLERİ

### Kurulum ergonomisi
- **`.env.example`** ekle (şablon).
- (42 subject uyumu için) **Makefile** ekle: `up/down/re/logs/ps/clean` hedefleri.

### Dayanıklılık
- Compose’a `restart: unless-stopped` ekle.
- Healthcheck ekle (DB ve WP için).

### Güvenlik hardening
- NGINX security headers (CSP/HSTS vb. dikkatli).
- WordPress admin güvenliği (rate limit/2FA plugin, güçlü şifre politikası).
- Secrets’i Docker secrets/vault gibi mekanizmalara taşıma.

### Performans
- PHP-FPM pool tuning
- NGINX gzip/cache
- MariaDB tuning (InnoDB buffer vb.)

---

## 8. GERÇEK HAYAT SENARYOSU (PRODUCTION/DEVOPS)

### Şirkette kullanım
- Küçük/orta ölçek WordPress siteleri için tek sunucu deployment.
- Staging ortamı: aynı compose, farklı `.env`.

### Production’da dikkat edilecekler
- Gerçek TLS (Let’s Encrypt) + otomatik yenileme
- Düzenli backup + restore testi
- Güncelleme stratejisi (WP core/tema/eklenti + image rebuild)
- Log/monitoring (NGINX, PHP-FPM, MariaDB)

### Deployment akışı (basit)
- CI: docker build, temel kontroller
- CD: `docker compose up -d` (tag yönetimi ile rollback)
- Secrets: `.env` yerine secret store

