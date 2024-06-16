FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

RUN apk add --no-cache nginx

COPY http.d /etc/nginx/http.d

ENTRYPOINT ["/usr/sbin/nginx","-g", "daemon off;"]

CMD ["-c", "/etc/nginx/nginx.conf"]

