FROM debian:bullseye

RUN apt update && apt install -y vsftpd

RUN echo "anonymous_enable=NO" >> /etc/vsftpd.conf && \
    echo "local_enable=YES" >> /etc/vsftpd.conf && \
    echo "write_enable=YES" >> /etc/vsftpd.conf && \
    echo "chroot_local_user=YES" >> /etc/vsftpd.conf && \
    echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf && \
    echo "seccomp_sandbox=NO" >> /etc/vsftpd.conf && \
    echo "pasv_enable=YES" >> /etc/vsftpd.conf && \
    echo "pasv_min_port=40000" >> /etc/vsftpd.conf && \
    echo "pasv_max_port=40010" >> /etc/vsftpd.conf && \
    echo "pasv_address=127.0.0.1" >> /etc/vsftpd.conf

# Başlangıç betiğini kopyala
COPY tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

# Konteyner başlarken bu betiği çalıştır
ENTRYPOINT ["/tmp/setup.sh"]
