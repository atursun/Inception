FROM debian:bullseye

RUN apt update && apt install -y curl git \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt install -y nodejs \
    && git clone https://github.com/louislam/uptime-kuma.git /app \
    && cd /app \
    && npm run setup

WORKDIR /app

EXPOSE 3001

CMD ["node", "server/server.js"]