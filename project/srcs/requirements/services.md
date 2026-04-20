# Inception Projesi Servisleri

Bu dosya, `project/srcs/requirements` klasörü altında bulunan servislerin ne işe yaradığını, nasıl çalıştığını ve uygulamalı olarak nasıl kullanılacağını açıklamaktadır. Projede temel mimari zorunlu servisler (NGINX, MariaDB, WordPress) ve ekstra özellikler katan bonus servislerden oluşmaktadır.

## 📌 Zorunlu Servisler (Core Services)

### 1. NGINX (`mariadb`, `nginx`, `wordpress` üçlüsünün giriş kapısı)
*   **Nedir?** Yüksek performanslı bir web sunucusu ve ters vekil (reverse proxy) sunucusudur.
*   **Nasıl Çalışır?** Inception projesi mimarisinde dışarıya (internete/kullanıcıya) açık olan **tek** servistir (sadece TLS/SSL ile 443 portu üzerinden). Kullanıcıdan gelen HTTPS isteklerini karşılar ve bu istekleri içeriğinde barındırdığı kurallara göre arka plandaki ilgili servislere yönlendirir.
*   **Nasıl Kullanılır?** 
    *   Projeyi `docker-compose up -d` ile ayağa kaldırdıktan sonra tarayıcınıza `https://<kullanici_adiniz>.42.fr` (örneğin: `https://login.42.fr`) yazarak siteye giriş yaparsınız.
    *   NGINX, TLS/SSL (kendi imzaladığınız sertifika) kullanacak şekilde ayarlandığından, tarayıcınız "Bağlantınız güvenli değil" uyarısı verebilir. Kurallara uygun olarak "Gelişmiş -> Güvenli olmayan siteye devam et" diyerek geçmelisiniz.
    *   Sizin NGINX'i "kullanmak" için ekstra bir arayüzü yoktur; arkadaki her şeye köprü görevi görür.

### 2. MariaDB
*   **Nedir?** Güçlü, açık kaynaklı ve MySQL tabanlı bir ilişkisel veritabanı yönetim sistemidir (RDBMS).
*   **Nasıl Çalışır?** Projede verilerin kalıcı olarak saklandığı yerdir. WordPress'in sitenize ait yayınlarını, kullanıcı giriş bilgilerini kaydeder. Dışarıdan erişime kapalıdır, yalnızca içerideki diğer konteynerlerle konuşur.
*   **Nasıl Kullanılır?** 
    *   MariaDB direkt bir önyüze (arayüze) sahip değildir. Arkada sessizce çalışır.
    *   Kurulum sırasında `.env` dosyanızdaki şifrelerle (örn: `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`) otomatik olarak yapılandırılır ve veritabanı hazır hale gelir.
    *   Veritabanını yönetmek veya manuel olarak (SQL sorgularıyla) kullanmak isterseniz, ek sisteme dahil edilen **Adminer**'ı kullanmalısınız veya `docker exec -it mariadb bash` komutuyla konteynere girerek terminalden `mysql` komutuyla kontrol etmelisiniz.

### 3. WordPress (PHP-FPM ile)
*   **Nedir?** Dünyanın en popüler ücretsiz İçerik Yönetim Sistemidir (CMS).
*   **Nasıl Çalışır?** Sitenin hem görüntülenen yüzünü hem de yönetim panelini çalıştırır. NGINX'den gelen istekleri okur, MariaDB'den yazar/okur ve sayfayı oluşturur.
*   **Nasıl Kullanılır?** 
    *   Tarayıcıdan ana domain'inize (örn: `https://<login>.42.fr`) girdiğinizde WordPress altyapılı kendi sitenizi görürsünüz.
    *   Yönetici işlemlerini yapmak, yeni yazı/sayfa eklemek, temayı düzenlemek için `https://<login>.42.fr/wp-admin` adresine gidin.
    *   Giriş ekranında, `WP_ADMIN_USER` ve `WP_ADMIN_PASSWORD` (genelde scriptinizde veya env'de yazar) bilgilerini kullanarak panele (dashboard) erişirsiniz.
    *   Inception projesindeki gerekliliklere göre zaten wp-cli kullanılarak içinde bir Admin bir de normal kullanıcı hazır oluşturulmuş olmalıdır.

---

## 🌟 Bonus Servisler

### 4. Adminer (`bonus/adminer`)
*   **Nedir?** Tek bir PHP dosyasından oluşan, veritabanı yönetim aracıdır.
*   **Nasıl Çalışır?** Web tarayıcısı üzerinden MariaDB veritabanınıza bağlanmanızı görsel olarak kolaylaştırır.
*   **Nasıl Kullanılır?** 
    *   Tarayıcınızda (projedeki NGINX yapılandırmanıza bağlı olarak) `https://<login>.42.fr/adminer` veya ayırdığınız özel bir port ile adrese gidilir.
    *   Giriş ekranı geldiğinde:
        * **Sistem (System):** MySQL seçilir.
        * **Sunucu (Server):** MariaDB konteynerinizin docker-compose içi adı girilir (genelde `mariadb`).
        * **Kullanıcı (Username) / Şifre (Password):** `.env` dosyanızdaki MySQL kullanıcı bilgileriniz girilir.
    *   **Veritabanı Yönetimi:** Giriş yaptıktan sonra sol menüden yönetmek istediğiniz veritabanını (örneğin WordPress veritabanınız: `wordpress`) seçin. Karşınıza sitenizin tüm tabloları (`wp_users`, `wp_posts`, `wp_comments` vb.) listelenecektir.
    *   **Veri/Yorum Ekleme ve Çıkarma:** Herhangi bir tabloya (örneğin WordPress yorumları için `wp_comments`) tıkladığınızda "Select data (Veriyi seç)" diyerek mevcut yorumları/verileri görebilir, yanlarındaki "Edit" veya kutucukları işaretleyip alttan "Delete (Sil)" diyerek silebilirsiniz. Yeni veri girmek için üstteki "New item (Yeni kayıt)" butonunu kullanabilirsiniz.
    *   **Kullanıcı Yönetimi (WordPress):** Sitedeki WordPress kullanıcılarını doğrudan veritabanından ekleyip çıkarmak için `wp_users` tablosuna girebilirsiniz. Yeni bir admin ekleyebilir (şifre kısmını MD5 ile şifreleyerek girmelisiniz) veya var olan birinin yetkilerini silebilirsiniz.
    *   **Kullanıcı Yönetimi (Veritabanı/MariaDB):** Sadece WordPress değil, MariaDB seviyesinde yeni bir veritabanı kullanıcısı (database user) oluşturmak isterseniz, Adminer ana ekranındayken üst menüdeki "Privileges (Ayrıcalıklar/Yetkiler)" sekmesine tıklayın. Buradan "Create login (Kullanıcı oluştur)" diyerek yeni bir veritabanı yöneticisi tanımlayabilirsiniz.

### 5. Redis (`bonus/redis`)
*   **Nedir?** Açık kaynaklı, bellek içi (in-memory) veri yapısı deposudur. Önbellek (cache) sunucusu olarak çalışır.
*   **Nasıl Çalışır?** WordPress, yordamlarının cevaplarını veritabanı yerine direkt Redis üzerinden RAM'den okur, sistemi çok hızlandırır.
*   **Nasıl Kullanılır?** 
    *   WordPress kurulumu (wp-cli) aşamasında Redis eklentisi otomatik kurulup aktifleştirilmiş olmalıdır (örn: "Redis Object Cache" eklentisi).
    *   Bunu test etmek için; WordPress'in admin paneline `/wp-admin` girilir, eklentiler bölümünden Redis eklentisine bakılır ve "Status: Connected (Bağlandı)" yazısı gözlemlenir.
    *   Terminal üzerinden kullanmak/test etmek isterseniz; `docker exec -it redis redis-cli monitor` komutunu çalıştırın. Ardından tarayıcınızda WordPress sitenizin farklı sayfalarına tıklayın. Terminale anlık olarak `GET` / `SET` loglarının akmaya başladığını göreceksiniz.

### 6. Statik Web Sitesi (`bonus/static-website`)
*   **Nedir?** HTML, CSS ve JS kullanılarak yazılmış statik tanıtım sayfasıdır. Veritabanı vb. arka ucu yoktur.
*   **Nasıl Kullanılır?** 
    *   Projenizde bunu genelde ana domain dışında farklı bir konuma eklersiniz. Örneğin `https://<login>.42.fr/portfolio` gibi bir rota (route) üzerinden veya NGINX tarafından proxy'lenen farklı bir port (örn: `8080`) üzerinden ulaşılır.
    *   Adrese girdiğinizde tasarımını sizin (veya bir şablonun) belirlediği statik site/CV vb. arayüz görünür, yönetici paneli yoktur, değişiklikler yalnızca kod düzenleyerek (`index.html` gibi) yapılır.

### 7. Uptime (`bonus/uptime`)
*   **Nedir?** Ağ üzerindeki servislerin (konteynerlerin) çalışıp çalışmadığını, çökme durumlarında süreyi ölçen monitör programıdır (Örn: Uptime Kuma).
*   **Nasıl Kullanılır (Site Kullanımı ve Detaylar)?** 
    *   **İlk Giriş ve Kurulum:** Belirlenen URL veya port (örn: `https://<login>.42.fr/uptime` veya `3001` portu) üzerinden panele erişilir. İlk açılışta sizden bir yönetici (Admin) hesabı oluşturmanız istenir. Bir kullanıcı adı ve güçlü bir şifre belirleyip giriş yapın.
    *   **Monitor (İzleyici) Ekleme:** Ana sayfadaki sol üst köşeden "Add New Monitor" (Yeni İzleyici Ekle) butonuna tıklayın. Ayarlar kısmında:
        *   **Monitor Type (İzleyici Tipi):** Web sitesini izleyecekseniz `HTTP(s)` seçin. Arka plan servislerini izleyecekseniz (Veritabanı veya Redis gibi) `TCP Port` seçin.
        *   **Friendly Name:** İzleyiciye anlaşılır bir isim verin (Örn: "Ana Web Sitesi", "MariaDB Veritabanı").
        *   **URL / Hostname:** `HTTP(s)` için web sitenizin adresini (`https://login.42.fr`), `TCP Port` için servisin Docker ağındaki adını yazın (örn: MariaDB için host kısmına `mariadb`, port kısmına `3306`; Redis için host `redis`, port `6379`).
        *   **Heartbeat Interval:** Bu izleyicinin kaç saniyede bir kontrol yapacağını (ping atacağını) belirler. (Varsayılan olarak 60 saniyede bir bırakabilirsiniz).
        *   "Save" (Kaydet) butonuyla izleyiciyi aktifleştirin.
    *   **Dashboard (Kontrol Paneli) Okuma ve Kullanım:** 
        *   Eklediğiniz tüm servisler ekranın sol tarafındaki listede toplanır. Birine tıkladığınızda ortada detaylı durum grafiği açılır.
        *   **Yeşil (Up) Durumu:** Servisin sorunsuz çalıştığını gösterir. Yüzdelik dilim (Örn: %100 Uptime), servisin ne kadar süredir aralıksız ulaşılabildiğini belirtir.
        *   **Kırmızı (Down) Durumu:** Servisin ulaşılamadığını (çöktüğünü) işaret eder. Sağdaki loglarda hatanın nedenini (örn: "Connection refused") görebilirsiniz.
        *   **Response Time (Yanıt Süresi):** Grafikte ayrıca servisinizin isteklere kaç milisaniyede (ms) yanıt verdiği görülür. Site yavaşlarsa buradan tespit edebilirsiniz.
    *   **Test Etme Sistemi:** Çalışıp çalışmadığını teyit etmek için terminalinizde `docker stop redis` yazarak servisi durdurun. Uptime paneline döndüğünüzde Redis'in "DOWN" durumuna (kırmızıya) geçtiğini anında (veya belirlediğiniz sürede) göreceksiniz. `docker start redis` komutuyla tekrar açtığınızda sistem tekrar kalpleri yeşile (UP) çevirecektir.
    *   **Bakım Modu ve Bildirimler:** Sunucuda bilerek bir işlem (güncelleme vb.) yapacaksanız, izleyicinin sağ üst köşesinden "Pause" (Duraklat) butonuna basarak log şişmesini önleyebilirsiniz. "Settings -> Notifications" bölümünden ise servis çöktüğünde Telegram, Discord veya Mail yoluyla otomatik uyarı atmasını bile konfigüre edebilirsiniz.

### 8. FTP Sunucusu (`bonus/ftp`)
*   **Nedir?** Bilgisayarlar veya sunucular arasında ağ üzerinden dosya transferi (yükleme ve indirme) yapmanızı sağlayan (File Transfer Protocol) standart bir veri aktarım servisidir.
*   **Nasıl Çalışır?** İstemci-sunucu (Client-Server) mimarisiyle çalışır. Inception projesindeki vsftpd sunucusu, arka planda güvenli dizin (chroot) sınırlandırması yaparak yalnızca izin verdiğiniz `.env` kullanıcısının WordPress dosyalarının bulunduğu `/var/www/html` klasörüne erişmesini sağlar. Dosya transferlerini başarılı kılması için pasif mod (Passive Mode) üzerinde belirli ağ kurallarını barındırır.
*   **Nasıl Kullanılır?** 
    *   **Klasörden Erişim (Program Kurmadan):** Kendi bilgisayarınızda (Windows) sıradan bir dosya klasörü açın. Üstteki adres çubuğuna `ftp://127.0.0.1` yazarak Enter'a basın. Karşınıza çıkan pencereye `.env` içindeki FTP kullanıcı adı ve şifrenizi girin.
    *   **FileZilla ile Erişim:** Daha profesyonel kullanım için bilgisayarınıza FileZilla (veya WinSCP) programını açın. Sunucu kısmına `127.0.0.1`, kullanıcı adı ve şifreye `.env` bilgilerinizi, Port kısmına ise `21` yazıp bağlanın.
    *   **Dosya Yönetimi:** Başarıyla giriş yaptıktan sonra tıpkı normal bir USB belleğin veya diskinizin içine girmiş gibi WordPress dizininizi listelenmiş göreceksiniz. WordPress yönetim paneline uğramadan sitenizin ana dosyalarını, tema ve eklentileri (plugins) sürükle-bırak mantığıyla doğrudan kopyalayabilir, değiştirebilir veya kendi cihazınıza indirebilirsiniz.
