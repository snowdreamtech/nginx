FROM snowdreamtech/alpine:3.20.2

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

# keep the docker container running
ENV KEEPALIVE=1 \
    NGINX_REDIRECT_WWW='none' \
    ACME_HOME='/root/.acme.sh' \
    ACME_BIN='/root/.acme.sh/acme.sh' \
    ACME_DEAFULT_CA='zerossl' \
    ACME_EMAIL='my@example.com' \
    ACME_SSL_PATH='/etc/nginx/ssl' \
    ACME_KEYLENGTH='ec-256' \
    ACME_DOMAIN='' \
    ACME_DOMAINS='' \
    ACME_WILDCARD=1 \
    ACME_DNS='' \
    ACME_WWW_ROOT='' \
    ACME_STANDALONE='none' \
    ACME_DEBUG=0


COPY nginx /etc/nginx

RUN apk add --no-cache socat \
    nginx=1.26.2-r0 \
    && mkdir -p ${ACME_SSL_PATH} \
    && wget -c https://github.com/acmesh-official/acme.sh/archive/refs/heads/master.zip \
    && unzip master.zip \
    && cd acme.sh-master \
    && ./acme.sh --install --home ~/.acme.sh -m my@example.com \
    && cd / \
    && rm -rfv master.zip \
    && rm -rfv acme.sh-master \
    && ln -s /root/.acme.sh/acme.sh /usr/local/bin/acme.sh \
    && acme.sh --upgrade --auto-upgrade \
    && acme.sh --set-default-ca --server ${ACME_DEAFULT_CA} 

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]