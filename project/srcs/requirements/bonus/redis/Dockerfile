FROM debian:bullseye

RUN apt update && apt install -y redis-server

# Redis ayarlarını dosyanın en altına doğrudan ekliyoruz (echo yöntemi)
RUN echo "bind 0.0.0.0" >> /etc/redis/redis.conf && \
    echo "maxmemory 20mb" >> /etc/redis/redis.conf && \
    echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "--protected-mode", "no"]

# docker exec -it redis redis-cli ping
# docker exec -it redis redis-cli monitor