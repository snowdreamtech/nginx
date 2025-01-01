FROM snowdreamtech/alpine:3.21.0

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Nginx Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Nginx on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/nginx" \
    org.opencontainers.image.base.name="snowdreamtech/nginx:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/nginx" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="1.26.2" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/nginx"

# keep the docker container running
ENV KEEPALIVE=1 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=1 \
    NGINX_VERSION=1.26.2-r3 

ARG GID=1000 \
    UID=1000  \
    USER=nginx \
    WORKDIR=/var/lib/nginx/html

# Create a user with UID and GID
RUN if [ "${USER}" != "root" ]; then \
    addgroup -g ${GID} ${USER}; \
    adduser -h /dev/null -u ${UID} -g ${USER} -G ${USER} -s /bin/sh -D ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi

COPY nginx /etc/nginx

RUN apk add --no-cache \
    nginx=${NGINX_VERSION} \
    && sed -i "s/^user.*/user ${USER};/g" /etc/nginx/nginx.conf \
    && find /  -name "nginx" -exec chown -Rv ${USER}:${USER} {} \; 

# Enable CAP_NET_BIND_SERVICE
RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    apk add --no-cache libcap; \
    setcap 'cap_net_bind_service=+ep' `which nginx`; \
    fi

# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

EXPOSE 80 443

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]