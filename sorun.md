
1. sistemi down yapıp sonrasında tekrar up yaptığımda 502 bad gateway hatası alıyorum (mecitin evosunun feedback'ine bak orada belirtilmiş)
    - genellikle sistemi DOWN yapıpı sonra tekrar UP yaptıktans sonrasında bu hata olur.
    - anlamı; nginx doğru bir şekilde başlamış ama arka plandaki servislerle iletişim yapamıyor/bağlanamıyor
    

2. docker network driver: Network driver, containerlar arası iletişimi yöneten Docker ağ katmanıdır. Inception projesinde bridge driver kullanarak nginx, wordpress ve mariadb servislerini aynı özel ağda haberleştiriyoruz.
3. subdomain (adminer, static-website)
4. resolver 
5. Upstream: Nginx’in bağlanacağı backend servis havuzu
6. http sorunu: uptime http ile çalışıyor https ile çalışması gerekiyor mu araştır ?
