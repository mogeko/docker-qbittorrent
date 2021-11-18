FROM alpine:3.14 as libtorrent_builder

RUN apk add --no-cache \
    autoconf automake binutils boost-dev cppunit-dev libtool linux-headers ncurses-dev openssl-dev zlib-dev \
    build-base clang tar

WORKDIR /workspace

ARG LIBTORRENT_VERSION
ADD https://github.com/arvidn/libtorrent/archive/refs/tags/v${LIBTORRENT_VERSION}.tar.gz /workspace
RUN tar -zxf v${LIBTORRENT_VERSION}.tar.gz -C . \
    && cd libtorrent-${LIBTORRENT_VERSION} \
    && ./autotool.sh \
    && ./configure CXXFLAGS="-std=c++14" --prefix=/workspace/pkg --with-libiconv \
    && CC=clang make -j$(nproc) \
    && make install-strip

FROM alpine:3.14 as qbittorrent_builder

RUN apk add --no-cache \
    boost-dev qt5-qtbase-dev qt5-qttools-dev \
    build-base clang tar

WORKDIR /workspace

COPY --from=libtorrent_builder /workspace/pkg /usr

ARG QBITTORRENT_VERSION
ADD https://github.com/qbittorrent/qBittorrent/archive/refs/tags/release-${QBITTORRENT_VERSION}.tar.gz /workspace
RUN tar -zxf release-${QBITTORRENT_VERSION}.tar.gz -C . \
    && cd qBittorrent-release-${QBITTORRENT_VERSION} \
    && ./configure --prefix=/workspace/pkg --disable-gui \
    && CC=clang make -j$(nproc) \
    && make install

FROM alpine:3.14

RUN apk add --no-cache busybox libgcc openssl qt5-qtbase zlib

COPY --from=libtorrent_builder /workspace/pkg /usr
COPY --from=qbittorrent_builder /workspace/pkg /usr

ADD --chown=1000:100 root /

EXPOSE 6881 6881/udp 8080

ENV QBT_WEBUI_PORT=8080

VOLUME [ "/config", "/downloads" ]

ENTRYPOINT [ "/run.sh" ]

CMD [ "--profile=/" ]
