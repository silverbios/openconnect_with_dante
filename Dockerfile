FROM alpine:latest

LABEL openconnect.documentation="https://www.infradead.org/openconnect/index.html"
ENV OPENCONNECT_CONFIG=/etc/openconnect/openconnect.conf
RUN set -xe \
    && mkdir -p $(dirname $OPENCONNECT_CONFIG) \
    && touch $OPENCONNECT_CONFIG
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \ 
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && \
    apk upgrade && \
    apk add shadow procps ca-certificates tzdata iptables iproute2 dumb-init openconnect openssl iputils net-tools curl dante-server xmlstarlet
RUN touch /etc/security/limits.conf && \
    echo "sockd - nofiles 65535" >> /etc/security/limits.conf
RUN addgroup openconnect && adduser openconnect -D -H -G openconnect
USER openconnect
ENTRYPOINT ["/bin/ash", "-c", "set -e && /openconnect/entrypoint.sh"]
STOPSIGNAL SIGINT

COPY ./data /openconnect
