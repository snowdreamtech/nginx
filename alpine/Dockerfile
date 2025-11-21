FROM snowdreamtech/alpine:3.22.2

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Nginx Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Nginx on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/nginx" \
    org.opencontainers.image.base.name="snowdreamtech/nginx:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/nginx" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="1.28.0" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/nginx"
    
# Switch to the user
USER root

# Set the workdir
WORKDIR /root

# keep the docker container running
ARG KEEPALIVE=1 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0 \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/debian#locales)
    LANG=C.UTF-8\
    UMASK=022 \
    DEBUG=false \
    PGID=0 \
    PUID=0  \
    USER=nginx \
    WORKDIR=/home/nginx

# keep the docker container running
ENV KEEPALIVE=${KEEPALIVE} \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/debian#locales)
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PGID=${PGID} \
    PUID=${PUID}  \
    USER=${USER} \
    WORKDIR=${WORKDIR} 

ENV NGINX_VERSION=1.28.0-r3 \
    ACME_SH_VERSION=3.1.0 \
    LE_WORKING_DIR=/home/nginx/.acme.sh \
    PATH=${PATH}:/home/nginx/.acme.sh

# Create a user with PUID and PGID
RUN if [ "${USER}" != "root" ] && [ ! -d "/home/${USER}" ] && [ "${PUID}" -ne 0 ] && [ "${PGID}" -ne 0 ]; then \
    addgroup -g ${PGID} ${USER}; \
    adduser -h /home/${USER} -u ${PUID} -g ${USER} -G ${USER} -s /bin/sh -D ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi
    
# Install nginx
COPY nginx /etc/nginx

# Install nginx
RUN apk update \
    && apk add --no-cache \
    nginx=${NGINX_VERSION} \
    && mkdir -p /etc/nginx/ssl \
    && sed -i "s/^user.*/user ${USER};/g" /etc/nginx/nginx.conf 

# Install acme.sh
RUN apk update \
    && apk add --no-cache \
    socat \
    cronie \
    && wget -c https://github.com/acmesh-official/acme.sh/archive/refs/tags/${ACME_SH_VERSION}.tar.gz \
    && tar zxvf ${ACME_SH_VERSION}.tar.gz \
    && cd acme.sh-${ACME_SH_VERSION} \
    && ./acme.sh --install --home /home/${USER}/.acme.sh -m my@example.com \
    && chown -Rv ${USER}:${USER} /home/${USER}/.acme.sh \
    && cd / \
    && rm -rfv ${ACME_SH_VERSION}.tar.gz \
    && rm -rfv acme.sh-${ACME_SH_VERSION} \
    && /home/${USER}/.acme.sh/acme.sh --upgrade --auto-upgrade \
    && /home/${USER}/.acme.sh/acme.sh --set-default-ca --server letsencrypt

# Enable CAP_NET_BIND_SERVICE
RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    setcap 'cap_net_bind_service=+ep' `which nginx`; \
    fi
    
EXPOSE 80 443

COPY entrypoint.d /usr/local/bin/entrypoint.d

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

ENTRYPOINT ["docker-entrypoint.sh"]