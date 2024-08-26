FROM snowdreamtech/alpine:3.20.2

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

# keep the docker container running
ENV KEEPALIVE=1 \
    ACME_DEAFULT_CA='zerossl'


COPY http.d /etc/nginx/http.d

RUN apk add --no-cache socat \
    nginx=1.26.2-r0 \
    && mkdir -p /etc/nginx/ssl \
    && /usr/sbin/nginx -c /etc/nginx/nginx.conf \
    && wget -c https://github.com/acmesh-official/acme.sh/archive/refs/heads/master.zip \
    && unzip master.zip \
    && cd acme.sh-master \
    && ./acme.sh --install --home ~/.acme.sh \
    && cd / \
    && rm -rfv master.zip \
    && rm -rfv acme.sh-master \
    && ln -s /root/.acme.sh/acme.sh /usr/local/bin/acme.sh \
    && acme.sh --upgrade --auto-upgrade \
    && acme.sh --set-default-ca --server ${ACME_DEAFULT_CA} 

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]