FROM debian:bullseye

RUN apt update && apt install -y nginx

COPY tools/index.html /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]