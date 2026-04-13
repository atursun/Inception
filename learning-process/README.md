# inception (9 nisanda projeye başlandı)

Bu proje, Docker kullanarak sistem yönetimi bilginizi genişletmeyi amaçlamaktadır.
Yeni kişisel sanal makinenizde çeşitli Docker imajlarını sanallaştıracaksınız.
Bu proje belirli kurallar altında farklı servislerden oluşan küçük bir altyapı kurmanızı istiyor.

## Docker Nedir ?
Docker; Uygulamalar oluşturmanı, test etmeni ve depolamanı sağlayan bir yazılım platformudur.
container (kapsayıcı) denilen izole ortamlar içinde uygulamları çalıştırmamızı sağlar. (vm ile farkı nedir)
Bu containerlar, uygulamanın tüm bağımlılıklarıyla birlikte (kütüphaneler, ayarlar, araçlar, işletim sistemi bileşenleri vs.) paketlenmesini sağlar.
Böylece uygulama, nerede çalışırsa çalışsın aynı şekilde davranır.
Docker, “Bilgisayarımda çalışıyor ama sunucuda/başka bir bilgisayarda çalışmıyor!” sorununu ortadan kaldırır.
Temel Amaç
- Yazılımı, çalışması için gerekli her şeyle birlikte tek bir pakette toplamak.
- Her ortamda (geliştirme, test, üretim) aynı şekilde çalışmasını sağlamak.
- Kurulum, yapılandırma ve bağımlılık sorunlarını ortadan kaldırmak.


-Deploy(Dağıtmak) -> Uygulamayı yayına almak/Uygulamayı çalışır hale getirmek/Sunucuya/cihaza yükleyip çalıştırmak
    - örnek olarak bir web sitesi yaptım ve sunucuya yüklediğimde deploy etmiş oluyorum.

-Port -> Portlar, temel olarak veri akışını doğru hedeflere yönlendirmek için kullanılan sanal veya fiziksel bağlantı noktalarıdır. yani, bilgisayarda veya bir ağ üzerinde verilerin geçiş yaptığı kapı gibidir.
Port, gelen verinin hangi program veya servise gideceğini belirler.
sabit port numaraları: 80 -> Web siteleri (HTTP) | 443 -> Güvenli web siteleri (HTTPS) | 22 -> SSH bağlantısı
Toplam 65.536 adet port vardır.
Her servis/uygulama kendi portunu dinler.
Bir bilgisayarda çalışan her uygulama (servis) belirli bir port numarasını sürekli kontrol eder.
Bu port üzerinden gelen veriyi bekler.
Buna port dinlemek (listening on port) denir.
kısacası, Her servis kendi portunu dinler → Her uygulama kendisine ayrılmış port numarasını sürekli kontrol eder ve bu porttan gelen bağlantıları kabul eder.

-Boot -> bir bilgisayarın veya cihazın açılırken işletim sistemini yükleme ve çalıştırma sürecine verilen isimdir. Yani cihazın “açılıp çalışır hale gelme” mekanizmasıdır.

-isolation -> Bir uygulamanın/servisin/sürecin diğerlerinden tamamen ayrılmış, kendi başına çalışan bir ortamda çalışması anlamına gelir. Diğer uygulamalar onunla çakışamaz, karışamaz, bozmaz.

-demo (gösterim) -> Demo, bir ürünün, uygulamanın, oyunun veya yazılımın deneme sürümü, tanıtım amaçlı kısa versiyonu veya örnek gösterimi demektir. Ürünün nasıl çalıştığını göstermek için hazırlanmış örnek sürümdür.
özellikleri göstermek, müşteriyi ikna etmek sunum veya tanıtım yapmak için kullanılır.

-monitoring(izleme) -> Bir sistemin, uygulamanın veya sunucunun performansını, sağlığını ve hatalarını sürekli olarak takip etme ve ölçme işlemidir. (monitoring örnekleri; GRAFANA, Prometheus)
monitoring şunları izleyebilir; CPU kullanımı, RAM tüketimi, Disk doluluk, Ağ trafiği

-Component(Bileşen) -> Bir uygulamanın küçük, bağımsız, tekrar kullanılabilir parçasıdır.
Component, belirli bir görevi yerine getiren, kendi içinde çalışan, bağımsız bir modüldür.
Bir uygulama, birçok component’in birleşmesiyle oluşur.

-localhost(127.0.0.1) -> localhost, kendi bilgisayarını ifade eden özel bir isimdir. “Kendi bilgisayarım” demektir.
    - http://localhost:3000 -> tarayıcıya yazarsan
    - “Kendi bilgisayarımda 3000 numaralı portta çalışan uygulamaya bağlan.” anlamına geliyor
kısacası, localhost = Senin kendi bilgisayarın. Dış internetle ilgisi yoktur.



## Docker Nedir ?
Eskiden, insanlar bir uygulamayı deploy ettiğinde local'de çalıştığını ama sunucunda veya 
başka bilgisayarlarda çalışmadığını fark etmişsindir.
bunun nedeni deploy ettiğin uygulama senin bilgisayarındaki bağımlılıklara bağlı olmasıdır.
senin bilgisayarında; 
doğru sürüm Node/Python, gerekli kütüphaneler, doğru ortam değişkenleri (env), doğru path ayarları, port sorunu
bunlar zaten bilgisayarında yüklü olduğu için uygulama çalışır.

Ama başka bir bilgisayarda bunlar yoktur, bu yüzden uygulama çalışmaz:
eksik kütüphane, farklı Node/Python/Java sürümü, yanlış PATH ve ENV

Yani, kısacası "benim PC’de çalışıyor ama başkasında çalışmıyor" sorunu ortaya çıkıyordu.

işte bu sorunu çözmek için yani Uygulamayı başka bir bilgisayarda da çalışacak şekle getirmek için
en uygun çözüm "uygulamayı Docker’la paketlemek" yani "Docker" kullanmak.

Docker'ın şöyle avantajı var; başka pc farklı işletim sistemine sahip olabilir
veya kütüphaneler yüklü olmayabilir kısacası, hiçbir bağımlılık olmayabilir
Fark etmez
Docker kullandığımızda kendi pc'mde yazdığım uygulama her yerde aynı şekilde çalışır.
Çünkü "Docker bütün bağımlılıkları yanına koyarak paketler"

Özetle, deploy ettiğin bir uygulamayı herkes her yerden çalıştırabilmesini istiyorsan
Docker ile kendi bilgisayarındaki bağımlılıkları paketlemen gerekiyor.

### Docker Kavramları
1. Image: Bir uygulamanın çalışması için gerekli her şeyin paketlenmiş hali
    - kod, kütüphane, bağımlılık..
2. Container: Image’in çalışan hali. Image = program | Container = çalışan program
    - Her container izole bir ortamdır. kendi dosya sistemi, portları, process’leri, paketleri vardır.
3. Dockerfile: Image’i nasıl oluşturacağını tanımladığın talimat dosyası.
    - Bu dosya sayesinde image’ı otomatik oluşturursun.
4. Registry: Image’ların saklandığı depo. (docker hub, github, AWS, gitlab)
    - Sen image’ı push edersin, başkaları pull eder.
5. Volume: Container içindeki verinin kalıcı tutulduğu depolama.
    - Container silinse bile volume’daki veri durur.
    - örnek veriler: veritabanı dosyaları, log dosyaları, kullanıcı yüklemeleri
6. Network: Container’ların birbirleriyle haberleşmesini sağlayan sanal ağ.
7. Port Mapping: Container iç ve dış portların eşleştirilmesi.
    - localhost:8080 → container:3000
8. Docker Compose: Birden fazla container’ı tek bir YAML (.yml) dosyasıyla yönetmeni sağlar.
    - backend, frontend, database hepsini tek bir komutla çalıştırırsın
9. Containerization: Containerization, bir uygulamanın çalışması için gereken her şeyle birlikte (kod, kütüphaneler, bağımlılıklar, config’ler) tek bir paket haline getirilip izole bir ortamda çalıştırılmasıdır.
Virtual machine gibi ağır değildir. Saniyeler içinde başlar.
VM (Sanal Makine) gibi kendi işletim sistemini taşımaz, sadece uygulamayı çalıştırmak için gerekli minimum ortamı taşır.
    - Bu sayede uygulama: Her bilgisayarda, Her işletim sisteminde, Aynı şekilde Sorunsuz çalışır.


# Örnek Senaryo
bir web uygulaması var ve bu uygulamanın altında farklı servisler var ve bu 
servisler farklı kütüphaneler ve bağımlılıklar kullandığında "çakışma" olabilir.
Yani, Servisler aynı makinede çalışıyorsa çakışma çok kolay olur.
örnek senaryolar
- Bir servis Python 3.8 ister, diğeri Python 3.11, aynı bilgisayarda aynı anda kullanmak zordur.
- İki servis aynı portu dinlemek ister (mesela ikisi de 3000).
- Bir servis PostgreSQL 14, diğeri PostgreSQL 16 ister — sürüm karmaşası çıkar.
Bu nedenle servisler arasında bağımlılık çakışması çok yaygın bir problemdir.

Bunun çözümü ise, Containerization'dır.
Her servisi kendi kutusuna koymak.
yani bir servis var ve servisin kullandığı kütüphaneleri, bağımlılıkları ayrı
ve izole bir şekilde diğer servislerden ayrı olacak şekilde paketlemek/koymak.
Böylece servisler birbirlerine asla karışmaz.
Peki Containerization bunu nasıl yapıyor.
- Her servis için ayrı bir Dockerfile yazılır
- Her Dockerfile kendi ortamını yaratır.

Örnek Çakışma durumu:
- Backend → Node 16
- Frontend → Node 20
Normalde aynı bilgisayarda sorun olur.
Ama Docker sayesinde:
Her ikisi de kendi Node sürümü ile çalışır.
Birbirlerini hiç görmezler → çakışma 0.

Özetle Containerization ile;
- Servisler birbirinden tamamen izole olur.
- Her servis farklı diller, farklı kütüphaneler, farklı sürümler kullanabilir.
- Port çakışmaları engellenir.
- Bağımlılık çakışmaları engellenir.
- Servisler bağımsız geliştirilir ve deploy edilir.

Her servis kendi container’ında → çakışma tamamen ortadan kalkar.


- Docker, containerlar ve işletim sistemi arasında olan bağlantıları kurar.
Container -> Docker <- OS

######################
- Dockerfile, Bir container’ın nasıl oluşturulacağını adım adım tanımlayan bir tarif (recipe) dosyasıdır.
“Benim container’ım şu işletim sisteminden başlasın, şu paketleri kursun, şu dosyaları içine alsın ve en sonunda şu komutla çalışsın.”
Docker bu dosyayı okuyup bir image oluşturur.
Image ise, Dockerfile'a yazdığımız adımları tek tek takip ederek çalıştırılmak üzere
hazır hale getiren bir pakettir.
Container ise, hazırladığımız bu image'ı çalıştıran bir uygulama.
- Akış: Dockerfile → docker build → image → docker run → container





######################


## Docker Client && Engine (server)
- Client: Terminalde yazdığın Docker komutlarını çalıştıran araçtır. Komutları Server’a gönderir.
    - Tek işi, Docker Engine’e istek göndermek.
- Server (Engine): Container’ları gerçekten çalıştıran motordur.
    - Asıl iş burada olur Container oluşturma, network kurma, storage yönetimi vs.
- İkisi farklı sürüm olabilir ve bu normaldir.

## Virtualization ve Containerization farkını güzel bir şekilde öğren



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

* Bizden README.md ve Documentations dosyaları istiyorlar

* Bizden istenilen Proje Klasör Yapısı (yine subjecten kontrol etmeyi unutma)
inception/
├── Makefile
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/
        │   └── tools/
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/
        │   └── tools/
        ├── tools/
        └── bonus/



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

- 192.168.49.1
- rsync -avz kullanici@VM_IP:/home/kullanici/klasor_adi/ ~/Desktop/klasor_adi/

---

## 🎯 Diyagramın Özeti (Tek Cümle)

> Bu mimaride **NGINX dış dünyaya açılan kapı**, **WordPress beynin kendisi**, **Database hafıza**, **Docker network özel iç yol**, **Volume ise kalıcı depodur**.




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
