FROM debian:bullseye

RUN apt update && apt install -y nginx 

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY www/ /var/www/html/

RUN chmod -R 755 /var/www/html/

EXPOSE 84

CMD ["nginx", "-g", "daemon off;"]
