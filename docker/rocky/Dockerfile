# Base Image (Rocky Variant)
# Extends snowdreamtech/rocky with additional tooling and configuration.

FROM snowdreamtech/rocky:10.2.0

# Build-time Configuration
ARG BUILDTIME \
    VERSION \
    REVISION \
    KEEPALIVE=1 \
    CAP_NET_BIND_SERVICE=0 \
    LANG=C.UTF-8 \
    UMASK=022 \
    DEBUG=false \
    PASSWORDLESS_SUDO=false \
    PGID=0 \
    PUID=0 \
    USER=root \
    WORKDIR=/root \
    NGINX_VERSION=1.26.3-6.el10_2.3 \
    ACME_SH_VERSION=3.1.3 \
    GITHUB_PROXY="https://gh-proxy.sn0wdr1am.com/"

# Standard OCI Metadata (https://github.com/opencontainers/image-spec)
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Nginx Image Based On Rocky" \
    org.opencontainers.image.description="Docker Images for Nginx on Rocky. (amd64, arm64, ppc64le, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/nginx" \
    org.opencontainers.image.base.name="snowdreamtech/rocky:10.2.0" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/nginx" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.created="${BUILDTIME}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/nginx"
# x-release-please-start-version
LABEL org.opencontainers.image.version="${VERSION:-1.26.3}"
# x-release-please-end

# Runtime Environment Configuration
ENV KEEPALIVE=${KEEPALIVE} \
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PASSWORDLESS_SUDO=${PASSWORDLESS_SUDO} \
    PGID=${PGID} \
    PUID=${PUID} \
    USER=${USER} \
    WORKDIR=${WORKDIR} \
    NGINX_VERSION=${NGINX_VERSION} \
    NGINX_WEB_ROOT=/var/www/html \
    ACME_SH_VERSION=${ACME_SH_VERSION} \
    LE_WORKING_DIR=/root/.acme.sh \
    PATH=${PATH}:/root/.acme.sh

# Install nginx
COPY nginx /etc/nginx

# Additional tooling and configuration for Nginx image
RUN dnf install -y epel-release \
    && dnf install -y \
    nginx-${NGINX_VERSION} \
    && mkdir -p /etc/nginx/ssl \
    && mkdir -p ${NGINX_WEB_ROOT} \
    && cp -a /usr/share/nginx/html/. ${NGINX_WEB_ROOT}/ \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Install acme.sh
RUN dnf install -y \
    socat \
    cronie \
    wget \
    tar \
    && cd /root \
    && wget -c ${GITHUB_PROXY}https://github.com/acmesh-official/acme.sh/archive/refs/tags/${ACME_SH_VERSION}.tar.gz \
    && tar zxvf ${ACME_SH_VERSION}.tar.gz \
    && cd acme.sh-${ACME_SH_VERSION} \
    && ./acme.sh --install --home /root/.acme.sh \
    && cd /root \
    && rm -rfv ${ACME_SH_VERSION}.tar.gz \
    && rm -rfv acme.sh-${ACME_SH_VERSION} \
    && /root/.acme.sh/acme.sh --upgrade --auto-upgrade \
    && /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Enable CAP_NET_BIND_SERVICE
RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    setcap 'cap_net_bind_service=+ep' `which nginx`; \
    fi

# Container Orchestration Files
COPY entrypoint.d /usr/local/bin/entrypoint.d

RUN chmod +x /usr/local/bin/entrypoint.d/*

# Standard Healthcheck (Verification of core system responsiveness)
HEALTHCHECK NONE

# Process Execution
EXPOSE 80 443
USER root
WORKDIR /root
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash"]
