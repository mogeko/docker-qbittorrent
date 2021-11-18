FROM alpine:edge as builder

RUN apk add --no-cache boost-dev build-base clang qt5-qtbase-dev qt5-qttools-dev libtorrent-rasterbar-dev tar

WORKDIR /workspace

ARG VERSION

ADD https://github.com/qbittorrent/qBittorrent/archive/refs/tags/release-${VERSION}.tar.gz /workspace

RUN tar -zxf release-${VERSION}.tar.gz -C . \
    && mv qBittorrent-release-${VERSION}/* . \
    && ./configure --prefix=/workspace --disable-gui \
    && CC=clang make \
    && make install

FROM alpine:edge

RUN apk add --no-cache busybox libcrypto3 libgcc libstdc++ libtorrent-rasterbar musl qt5-qtbase zlib

COPY --from=builder /workspace/bin/qbittorrent-nox /usr/bin/qbittorrent-nox

ADD --chown=1000:100 root /

EXPOSE 6881 6881/udp 8080

ENV QBT_WEBUI_PORT=8080

VOLUME [ "/config", "/downloads" ]

ENTRYPOINT [ "/run.sh" ]

CMD [ "--profile=/" ]
