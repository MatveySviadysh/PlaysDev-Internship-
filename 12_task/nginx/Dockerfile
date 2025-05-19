FROM nginx:1.24.0-alpine

RUN apk add --no-cache \
    supervisor \
    bash \
    nginx-mod-http-image-filter \
    procps \
    grep \
    sed \
    gawk


COPY supervisord.conf /etc/supervisord.conf
COPY nginx_logger.sh /usr/local/bin/nginx_logger.sh
RUN chmod +x /usr/local/bin/nginx_logger.sh

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/main.conf /etc/nginx/conf.d/

COPY html/ /usr/share/nginx/html/

COPY letsencrypt/live/nginxdocker123.ddns.net/privkey.pem /etc/letsencrypt/live/nginxdocker123.ddns.net/privkey.pem
COPY letsencrypt/live/nginxdocker123.ddns.net/fullchain.pem /etc/letsencrypt/live/nginxdocker123.ddns.net/fullchain.pem
COPY letsencrypt/options-ssl-nginx.conf /etc/letsencrypt/options-ssl-nginx.conf
COPY letsencrypt/ssl-dhparams.pem /etc/letsencrypt/ssl-dhparams.pem

RUN mkdir -p /var/log /var/run /var/cache/nginx /supervisor && \
    chown -R nginx:nginx /var/log /var/cache/nginx /etc/nginx /supervisor && \
    chmod -R 755 /var/log /var/run && \
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid && \
    touch /supervisord.pid && \
    chown nginx:nginx /supervisord.pid && \
    chmod 644 /etc/letsencrypt/live/nginxdocker123.ddns.net/*.pem && \
    chmod 644 /etc/letsencrypt/options-ssl-nginx.conf && \
    chmod 644 /etc/letsencrypt/ssl-dhparams.pem && \
    chown -R nginx:nginx /run


RUN sed -i '/^user/d' /etc/nginx/nginx.conf

USER nginx

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]