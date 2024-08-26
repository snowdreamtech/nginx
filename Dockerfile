FROM snowdreamtech/alpine:3.20.2

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

COPY nginx /etc/nginx

RUN apk add --no-cache nginx=1.26.2-r0 \
    && /usr/sbin/nginx -c /etc/nginx/nginx.conf

ENTRYPOINT [ "sh", "-c", "trap : TERM INT; tail -f /dev/null & wait" ]
