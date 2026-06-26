# Base Image (Debian Variant)
# Extends snowdreamtech/debian with additional tooling and configuration.

FROM snowdreamtech/debian:13.5.0

# Build-time Configuration
ARG BUILDTIME \
    VERSION \
    REVISION \
    DEBIAN_FRONTEND=noninteractive \
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
    NGINX_VERSION=1.26.3-3+deb13u6 \
    ACME_SH_VERSION=3.1.3 \
    GITHUB_PROXY="https://gh-proxy.sn0wdr1am.com/"

# Standard OCI Metadata (https://github.com/opencontainers/image-spec)
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Nginx Image Based On Debian" \
    org.opencontainers.image.description="Docker Images for Nginx on Debian. (i386, amd64, arm32v5, arm32v7, arm64, riscv64, ppc64le, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/nginx" \
    org.opencontainers.image.base.name="snowdreamtech/debian:13.5.0" \
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
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND} \
    KEEPALIVE=${KEEPALIVE} \
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
    ACME_SH_VERSION=${ACME_SH_VERSION} \
    LE_WORKING_DIR=/root/.acme.sh \
    PATH=${PATH}:/root/.acme.sh

# Install nginx
COPY nginx /etc/nginx

# Additional tooling and configuration for Nginx image
RUN set -eux \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy install --no-install-recommends -o Dpkg::Options::="--force-confold" \
    nginx=${NGINX_VERSION} \
    && mkdir -p /etc/nginx/ssl \
    && rm -rfv /etc/nginx/sites-available/* \
    && rm -rfv /etc/nginx/sites-enabled/* \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy --purge autoremove \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Install acme.sh
RUN set -eux \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy install --no-install-recommends \
    socat \
    cron \
    wget \
    ca-certificates \
    && cd /root \
    && wget -c ${GITHUB_PROXY}https://github.com/acmesh-official/acme.sh/archive/refs/tags/${ACME_SH_VERSION}.tar.gz \
    && tar zxvf ${ACME_SH_VERSION}.tar.gz \
    && cd acme.sh-${ACME_SH_VERSION} \
    && bash ./acme.sh --install --home /root/.acme.sh \
    && cd /root \
    && rm -rfv ${ACME_SH_VERSION}.tar.gz \
    && rm -rfv acme.sh-${ACME_SH_VERSION} \
    && /root/.acme.sh/acme.sh --upgrade --auto-upgrade \
    && /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy --purge autoremove \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

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
