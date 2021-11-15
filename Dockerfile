FROM alpine:edge

ARG VERSION

RUN apk add --no-cache \
    -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    qbittorrent-nox=${VERSION}

ADD --chown=1000:100 qBittorrent.conf /qBittorrent/config/

RUN chmod -R g+w /qBittorrent

EXPOSE 6881 6881/udp 8080

ENV QBT_WEBUI_PORT=8080

VOLUME [ "/downloads" ]

ENTRYPOINT [ "/usr/bin/qbittorrent-nox" ]

CMD [ "--profile=/" ]
