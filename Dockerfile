FROM snowdreamtech/alpine:3.20.2

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

RUN apk add --no-cache nginx=1.26.1-r0

COPY http.d /etc/nginx/http.d

ENTRYPOINT ["/usr/sbin/nginx","-g", "daemon off;"]

CMD ["-c", "/etc/nginx/nginx.conf"]

