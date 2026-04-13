
Projeyi yaparken attığın adımlar ve öğrendiğin şeylerin listesi/adımları
d
1. sanal makine de SİSTEM KURULUMU yaptık

2. sonrasında SİSTEM YAPILANDIRILMASI yaptık
	- sudo kurulumu, kullanıcıyı sudo grubuna ekleme ve tam yetkilendirme
	- ekranı tam yapma (guest edition/display settings)
	- gerekli paketlerin/servislerin kurulumu (git, vscode, docker.io, docker-compose, ssh)

3. Proje
	1. Proje Klasörü Oluşturma (requirements/*) 
	2. Servislerin Kurulumu (Nginx, WordPres, MariaDB)
        - Nginx: sudo apt install nginx
        - MariaDB: sudo apt install mariadb-server
        - WordPress: Nginx ve MariaDB yapılandırıldıktan sonra kurulacak.
	3. Nginx servisini docker ile çalıştırma (nginx servisini indirdim daha sonra Dockerfile yazdım ve container için de nginx yükledim sonra çalştırdım örnek olması açısından www/index.html oluşturdum, nginx.conf dosyasını yazdım, DOMAIN-IP eşleşmesi yaptım /etc/hsots) (yani kısacası nginx servisini kurup yapılandırdım) (tek kalan şey ise, portu 443 yapmam ve TLS..)
	4.WordPress + php-form, servisini yükle ve yapılandır.


aslında senin servisleri kurman onları yapılandırıp birbirleriyle ilişki yapman ve böyle bir ortam yapman bir sunucu mantığıdır.

- Sunucu (server) dediğin şey aslında tek bir program değil, birlikte çalışan servislerin oluşturduğu bir sistemdir.
