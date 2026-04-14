1. nginx ve wordpress'in ortak volume olmamamsı:
Kullanıcı senin portuna giriyor (443), Nginx karşılayıp sertifikayı hallediyor. Ardından "/var/www/html klasöründeki index.php dosyasını getireyim" diyor. Kendi klasörüne bakıyor ama WordPress dosyaları orada yok (WordPress kendi container'ında hapiste kaldı). İsteği proxy ile 9000 portuna (WordPress'e) yollasa da, SCRIPT_FILENAME eşleşmediği için "File not found." veya "404" hatası patlıyor.

2. Nginx Ayarlarında "Mime.types" Eksikliği:

3. .env file'ı docker'a tanıtmamaışım

