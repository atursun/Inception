# inception (9 nisanda projeye başlandı)

# Proje Bittikten Sonra Ne Yapmış Oluyorum ?
Bu projede, bir sanal makine üzerinde Docker kullanarak çalışan bir web altyapısı kurmuş olacaksın.
NGINX, WordPress ve MariaDB servislerini ayrı container’larda çalıştırıp birbirine bağlamış olacaksın.
Sistemi HTTPS (TLS) ile güvenli hale getirip tek giriş noktası oluşturmuş olacaksın.
Verileri volume kullanarak kalıcı hale getirmiş ve servisleri otomatik yönetilebilir yapmış olacaksın.
Sonuç olarak, gerçek hayattaki bir web sunucu altyapısını sıfırdan kurmayı öğrenmiş olacaksın.
"Ben sadece bir web sitesi kurmadım, o web sitesini çalıştıran tüm sistemi kurdum"



# ÖNEMLİ

Kendi bilgisayarımdakiler
----
hostname -> abdullah
domain-name -> atursun.42.fr
root password -> 2332
username -> apo | şifresi -> 233


# ----Subject---

# Mandatory Part

- 1️⃣ Genel Çalışma Ortamı Zorunlulukları
    1. Projeyi Kendi bilgisayarında değil, bir sanal makine (vm) içinde yaplımalıdır.
    amaç, Gerçek sunucu ortamını simüle etmek ve Sistem yöneticiliği bakış açısı kazanmak.
    2. Servisleri tek tek `docker run` ile ayağı kaldırmaktansa, Tüm servisler `docker-compose.yml` ile ayağa kaldırılmalıdır. Servislerin birbirleriyle ilişkisi **compose üzerinden** yönetilmelidir.
    3. **Tüm konfigürasyon dosyaları** `srcs/` klasörü içinde olmalı.
    Root dizinde mutlaka: `Makefile`, `README.md` diğer .md dosyaları olmalı
    4. Makefile ile program inşa edilmelil. make komutu ile; Docker image’ları build etmeli, Docker Compose ile container’ları ayağa kaldırmalı. amaç, “Projeyi tek komutla çalıştırabiliyor musun?

- 2️⃣ Docker Image & Container Kuralları
    1. Her servis için ayrı Docker image/container üretilmeli. 3 farklı servis varsa 3 farklı container olmak zorundadır. NGINX, WordPress, MariaDB **ayrı container'lar içinde** olacak
    2. Image isimleri servis adıyla aynı olmalı.
    3. Docker image’lar, yalnızca Alpine veya Debian’ın sondan bir önceki stabil sürümünden türetilmelidir. Ubuntu, latest tag ve hazır image kullanımı yasaktır çünkü projenin amacı servisleri sıfırdan kurup konfigüre edebildiğimizi göstermektir. (Base image kısıtı)
    4. DockerHub'dan hazır image almak veya önceden yapılandırılmış servisleri kullanmak yasaktır.
    serbest olanları, `FROM alpine:3.xx` ve `FROM debian:xx`

- 3️⃣ Kurulması Zorunlu Servisler
    1. NGINX Container: container içinde sadece NGINX servisi olacak.
    **Sadece HTTPS (443)**, **TLSv1.2 veya TLSv1.3**. Sisteme **tek giriş noktası**
    2. WordPress + php-fpm Container: Container'ın içinde sadece WordPress ve php-fpm olmalı.
    WordPress, NGINX’e php-fpm üzerinden bağlanacak
    3. MariaDB Container: container içinde MariaDB servisi olacak. 
    Veritabanı sadece WordPress tarafından kullanılacak

- 4️⃣ Volume Zorunlulukları
    1. WordPress Veritabanı için Volume: WordPress’in kullandığı veritabanı (MariaDB) KALICI olmalı.
    Yani container silinse bile, veritabanı silinmemeli.
    2. WordPress Site Dosyaları için Volume: WordPress’in site dosyaları (tema, eklenti, upload, core dosyalar) KALICI olmalı.Container silinse bile site dosyaları silinmemeli. 

- 5️⃣ Network Zorunlulukları
    1. docker-network: Tüm container’lar, senin oluşturduğun ÖZEL (custom) bir Docker network içinde olmalı ve birbirleriyle bu network üzerinden haberleşmeli.

- 6️⃣ Güvenlik ve Çalışma Kuralları
    1. Container'lar crash olursa yeniden başlatılmalı.
    2. Infinite loop forbidden: Bir Docker container, sonsuz döngüyle ayakta tutulamaz.
    Docker container sonsuz döngülerle ayakta tutulmaz. tail -f, sleep infinity, while true veya bash gibi komutlar yasaktır çünkü container bir virtual machine değildir. Docker’da container’ın çalışıp çalışmadığını belirleyen şey PID 1’dir ve bu gerçek servis süreci olmalıdır (nginx, php-fpm, mysqld gibi). Servisler foreground çalıştırılmalı, daemon olarak arka plana atılmamalıdır. Amaç, container’ın hileyle değil doğru Docker mantığıyla çalıştığını göstermektir. (PID 1’dir subjecte bak mavi etiketli yere)

- 7️⃣ WordPress Veritabanı Kullanıcıları
    1. WordPress Veritabanı'nda 2 kullanıcı olması gerekiyor.
    bir normal kullanıcı ve bir tane admin kullanıcısı olması gerekiyor.
    2. Admin'nin kullanıcı adı; admin, Admin, administrator, admin123 veya administrator42 olamaz.
    kapsamlı olması gerekiyor. Farklı, özgün bir admin username olmalı.

- 8️⃣ Domain & SSL Zorunlulukları
    1. Domain adı, *login.42.fr* formatında olması gerekiyor. yani *atursun.42.fr*
    2. Bu domain, sunucunun local IP adresine yönlendirilmelidir.
    Yönlendirme, `/etc/hosts` dosyası üzerinden yapılabilir.


- ÖNEMLİ("Dockerfile yazarken PID 1 (process ID 1) hakkında bilgi edin ve en iyi uygulamaları öğren")


- 9️⃣ Environment Variables & Secrets (subjecteki ! tabelalı kırmızı alanı oku)
    1. Docker image’larda *latest* etiketi yasaktır, çünkü sürüm belirsizliği yaratır; kullanılan sürüm açıkça belirtilmelidir.
    2. Dockerfile içinde hiçbir şifre veya gizli bilgi bulunamaz; tüm yapılandırmalar environment variable olarak tanımlanmalı ve bu değişkenler zorunlu olarak .env dosyasından alınmalıdır.
    3. Veritabanı şifreleri, root parolaları ve benzeri hassas bilgiler için *Docker secrets* kullanımı şiddetle önerilir ve Git deposunda herhangi bir gizli bilgi bulunursa proje doğrudan başarısız sayılır.
    4. Ayrıca güvenlik gereği, altyapıya dış dünyadan erişebilen tek container NGINX olmalı ve bu erişim sadece 443 portu üzerinden, TLSv1.2 veya TLSv1.3 ile sağlanmalıdır.

- UYARI
    - Açık güvenlik sebepleriyle, tüm gizli bilgiler (credentials, API key, şifre vb.) yerel olarak farklı dosyalarda saklanmalı ve git tarafından kesinlikle yok sayılmalıdır (ignored | .gitignore dosyası).
    🔒 Şifre = sadece local, git’te ASLA yok. Aksi → FAIL.

- ÖNERİ
    - Alan adı gibi değişkenleri (.env gibi) bir environment variable dosyasında saklayabilirsin.
    Ortama göre değişebilecek bilgileri .env dosyasına koy
    .env gitignore’da olmalı. GitHub’a push edilmemeli. (NEDENİNİ ÖĞREN)

######
- Sonuç: Subjec'teki diyagram Docker kullanılarak kurulmuş bir WordPress web sitesinin mimarisini adım adım gösteriyor.

Bu diyagram **Docker kullanılarak kurulmuş bir WordPress web sitesinin mimarisini** adım adım gösteriyor. Baştan sona, dış dünyadan (internet) verinin nasıl gelip WordPress’in nasıl çalıştığını çok net şekilde açıklayayım.

---

## 🖥️ 1. Computer HOST (Ana Makine)

En dış çerçevede gördüğün **Computer HOST**, senin gerçek sunucun ya da bilgisayarın:

* Fiziksel makine veya VPS
* Docker burada çalışıyor
* Tüm container’lar bu makinenin içinde

> Yani Docker, bu host üzerinde izole mini sistemler (container’lar) çalıştırıyor.

---

## 🌐 2. WWW (İnternet) → NGINX (443)

En üstte **WWW** var:

* Kullanıcı tarayıcıdan siteye giriyor
  👉 `https://siteadi.com`

Bu istek:

* **443 portu** üzerinden geliyor (HTTPS)

⬇️
Bu istek doğrudan **NGINX container**’ına ulaşıyor.

> 🔒 443 = HTTPS
> NGINX burada **kapı görevlisi (reverse proxy)** gibi çalışıyor.

---

## 📦 3. Docker Network (Özel İç Ağ)

Gri alanın tamamı **Docker network**:

* Container’lar **aynı özel ağ içinde**
* Dışarıdan doğrudan erişilemezler
* Birbirleriyle **container isimleri üzerinden** haberleşirler

Bu ağ içinde 3 ana container var:

---

## 🧱 4. Container NGINX (Web Server)

**Görevi:**

* İnternetten gelen istekleri almak
* HTML, CSS, JS gibi statik dosyaları sunmak
* PHP isteklerini WordPress-PHP container’ına yönlendirmek

**Bağlantı:**

* WordPress-PHP ile **9000 portu** üzerinden konuşur

```text
NGINX ──(9000)──> WordPress + PHP-FPM
```

> NGINX PHP çalıştırmaz, sadece yönlendirir.

---

## 🐘 5. Container WordPress + PHP

**Görevi:**

* WordPress’in kendisi burada
* PHP kodları burada çalışır
* Kullanıcının istediği sayfayı oluşturur

**İki yönlü bağlantısı var:**

### 🔁 NGINX ile:

* PHP isteklerini alır
* HTML çıktısını NGINX’e geri gönderir

### 🔁 DB ile:

* Yazılar, kullanıcılar, ayarlar için veritabanına bağlanır
* **3306 portu** kullanılır

```text
WordPress ──(3306)──> Database
```

---

## 🗄️ 6. Container DB (Veritabanı – MySQL/MariaDB)

**Görevi:**

* WordPress verilerini saklar:

  * Yazılar
  * Kullanıcılar
  * Şifreler
  * Ayarlar

**Önemli nokta:**

* Dış dünyaya açık **DEĞİL**
* Sadece WordPress container erişebilir

---

## 💾 7. Volumes (Kalıcı Veri)

Altta gördüğün silindirler **Volume**’leri temsil eder.

### 📌 DB Volume

* Veritabanı verileri burada tutulur
* Container silinse bile:

  * Yazılar
  * Kullanıcılar
    **kaybolmaz**

### 📌 WordPress Volume

* `wp-content` klasörü
* Tema, eklenti, yüklenen görseller burada

> Volume = **Docker container ölse bile veri yaşar**

---

## 🔌 8. Portlar Ne Anlama Geliyor?

| Port | Nerede            | Anlamı  |
| ---- | ----------------- | ------- |
| 443  | WWW → NGINX       | HTTPS   |
| 9000 | NGINX → WordPress | PHP-FPM |
| 3306 | WordPress → DB    | MySQL   |

---

## 🔄 9. Bir Kullanıcı Siteye Girdiğinde Ne Olur?

1. Tarayıcı → `https://site.com`
2. İstek **443** ile NGINX’e gelir
3. NGINX:

   * Statik dosya ise kendisi verir
   * PHP ise WordPress’e yollar
4. WordPress:

   * Gerekirse DB’den veri çeker
   * Sayfayı oluşturur
5. HTML çıktı:

   * WordPress → NGINX → Kullanıcı

---

## 🎯 Diyagramın Özeti (Tek Cümle)

> Bu mimaride **NGINX dış dünyaya açılan kapı**, **WordPress beynin kendisi**, **Database hafıza**, **Docker network özel iç yol**, **Volume ise kalıcı depodur**.
