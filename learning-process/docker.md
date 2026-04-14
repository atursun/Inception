Dockerfile, Docker dünyasında bir container’ın **nasıl oluşturulacağını adım adım tanımlayan bir tarif (recipe)** dosyasıdır. Yani sen Dockerfile yazarak şunu söylersin:

> “Benim container’ım şu işletim sisteminden başlasın, şu paketleri kursun, şu dosyaları içine alsın ve en sonunda şu komutla çalışsın.”

Docker bu dosyayı okuyup bir **image** oluşturur. Sonra bu image’dan container çalıştırılır.

---

# 🐳 Dockerfile Nedir? (Basit Mantık)

Akış şöyle:

```
Dockerfile → docker build → image → docker run → container
```

* **Dockerfile** → plan / tarif
* **image** → hazır sistem snapshot’ı
* **container** → çalışan uygulama

---

# 📦 Senin Dockerfile’ının Tam Açıklaması

Şimdi yazdığın Dockerfile’ı **satır satır, mantığıyla** açıklayalım:

---

## 🧱 1. Base Image

```dockerfile
FROM debian:bullseye
```

👉 Bu satır:

* Container’ın temelini belirler
* Sen burada **Debian Linux (bullseye)** kullanıyorsun

📌 Yani aslında:

> “Ben sıfırdan değil, hazır bir Linux üstüne kurulum yapacağım”

---

## 📥 2. Paket Kurulumu

```dockerfile
RUN apt update && apt install -y nginx openssl
```

👉 `RUN` ne demek?

* Image build edilirken komut çalıştırır

Bu satırda:

* `apt update` → paket listesi güncellenir
* `nginx` → web server
* `openssl` → SSL sertifikası üretmek için

📌 Sonuç:

> Container içinde NGINX kurulu bir sistem oluştu

---

## 🔐 3. SSL Klasörleri + Sertifika Oluşturma

```dockerfile
RUN mkdir -p /etc/ssl/certs /etc/ssl/private && \
```

👉 `mkdir -p`:

* klasör yoksa oluşturur
* varsa hata vermez

---

### 🔑 Sertifika Komutu

```dockerfile
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
```

Bu komut:

👉 self-signed SSL sertifikası üretir

Detay:

* `-x509` → self-signed sertifika
* `-nodes` → şifresiz private key
* `-days 365` → 1 yıl geçerli
* `-newkey rsa:2048` → yeni RSA key

---

```dockerfile
-keyout /etc/ssl/private/key.pem
```

👉 private key (gizli anahtar)

---

```dockerfile
-out /etc/ssl/certs/cert.pem
```

👉 public certificate

---

```dockerfile
-subj "/CN=atursun.42.fr"
```

👉 domain tanımı

📌 Çok önemli:

> Sertifika sadece bu domain için geçerli

---

## 📂 4. Config Dosyasını Kopyalama

```dockerfile
COPY conf/nginx.conf /etc/nginx/nginx.conf
```

👉 `COPY` ne yapar?

* Host makineden → container içine dosya alır

Burada:

* kendi yazdığın nginx.conf
* default config’i override eder

---

## 🌐 5. Web Dosyalarını Kopyalama

```dockerfile
COPY www/ /var/www/html/
```

👉 index.html container içine taşınır

📌 Bu sayede:

> NGINX açıldığında sayfa gösterebilir

---

## 🔒 6. Dosya İzinleri

```dockerfile
RUN chmod -R 755 /var/www/html/
```

👉 Bu:

* NGINX’in dosyaları okuyabilmesini sağlar

İzin anlamı:

* owner → full
* diğerleri → read + execute

---

## 🌍 7. Port Açma

```dockerfile
EXPOSE 443
```

👉 Bu sadece bilgi verir:

* “Bu container 443 portunu kullanıyor”

📌 Ama tek başına port açmaz!

* `docker run -p` ile map yapılır

---

## ▶️ 8. Container Başlatma Komutu

```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```

👉 Bu en kritik satırlardan biri

Normalde:

* NGINX arka planda çalışır (daemon) ❌
* Docker ise foreground ister ✅

---

### 🔥 `daemon off;` neden önemli?

```bash
nginx -g "daemon off;"
```

👉 Bu:

* NGINX’i foreground’da çalıştırır
* container kapanmasını engeller

📌 Eğer bunu yazmazsan:

> container anında kapanır ❌

---

# 🧠 Dockerfile’daki Komutların Özeti

| Komut  | Ne işe yarar                     |
| ------ | -------------------------------- |
| FROM   | Base image seçer                 |
| RUN    | Build sırasında komut çalıştırır |
| COPY   | Dosya kopyalar                   |
| EXPOSE | Port bilgisini belirtir          |
| CMD    | Container başlatma komutu        |




#####################
Container içinde kurduğun paketler (örneğin nginx, openssl), oluşturduğun dosyalar (/var/www, /etc/ssl gibi dizinler) ve yaptığın tüm ayarlar yalnızca o container’a özeldir. Bunun temel sebebi Docker’ın izole (isolated) ortamlar oluşturmasıdır. Yani host sistem (senin bilgisayarın) ile container birbirinden bağımsız çalışır.

Container aslında küçük bir Linux sistemi gibi davranır. Örneğin container içinde `apt install nginx` komutunu çalıştırdığında bu kurulum sadece container içinde gerçekleşir; host sistemine hiçbir etkisi olmaz. Bu yüzden host makinede nginx kurulu olmayabilirken, container içine girip kontrol ettiğinde nginx’in çalıştığını görebilirsin.

Ancak burada önemli bir nokta vardır: container’lar geçicidir. Eğer bir container’ı silersen (`docker rm`), içinde bulunan her şey tamamen yok olur. Yani kurduğun paketler, oluşturduğun dosyalar ve SSL sertifikaları dahil tüm veriler silinir. Bu yüzden Docker’da veri kalıcılığı varsayılan olarak yoktur.

Kalıcı veri ihtiyacı için “volume” kullanılır. Volume’ler, veriyi container’ın dışına, host sistemde özel bir alana yazar. Böylece container silinse bile veriler kaybolmaz. Inception projesinde de bu yüzden WordPress dosyaları ve MariaDB veritabanı için ayrı volume’ler kullanılır.

Burada image ve container farkını da iyi anlamak gerekir. Image, Dockerfile’dan oluşturulan ve değişmeyen bir yapıdır; bir nevi şablondur. Container ise bu image’ın çalışan halidir ve tüm değişiklikler burada gerçekleşir. Yani Dockerfile içinde yaptığın işlemler image’a yazılır ve kalıcıdır, fakat container çalışırken yapılan değişiklikler geçicidir.

Özetle, container içindeki her şey izoledir ve container silindiğinde yok olur. Eğer verinin kalıcı olmasını istiyorsan volume kullanman gerekir.


######DOCKER_KOMUTLARI########
1. docker build -t <image-adı> .

2. docker run -d -p <HOST_PORT>:<CONTAINER_PORT> --name <container_name> <image_name>

3. docker stop <container_name>

4. docker rm <container_name>

5. docker ps

6. docker network create <network_adı>

7. docker compose up --build <-d>



