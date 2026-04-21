FROM debian:bullseye

RUN apt update && apt install -y redis-server

# Redis ayarlarını dosyanın en altına doğrudan ekliyoruz (echo yöntemi)
# bind 0.0.0.0: "Sadece kendi içinde (localhost) değil, diğer konteynerlerden (WordPress'ten) gelen bağlantıları da kabul et."
# maxmemory 20mb: "Bu verileri saklamak için RAM'in en fazla 20 Megabayt'ını kullan." (Yoksa Redis bütün RAM'i yutabilir).
# maxmemory-policy allkeys-lru: "Eğer bu 20 MB dolarsa, (LRU - Least Recently Used), yani en son kullanılan (en eski ve gereksiz) verileri silip yenilerine yer aç."
RUN echo "bind 0.0.0.0" >> /etc/redis/redis.conf && \
    echo "maxmemory 20mb" >> /etc/redis/redis.conf && \
    echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "--protected-mode", "no"]

# docker exec -it redis redis-cli ping
# docker exec -it redis redis-cli monitor