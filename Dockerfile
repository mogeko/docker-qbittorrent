FROM alpine:3.14 as libtorrent_builder

RUN apk add --no-cache boost-dev build-base clang-dev cmake libtool openssl-dev git

WORKDIR /workspace

ARG LIBTORRENT_VERSION
ARG LIBTORRENT_GIT=https://github.com/arvidn/libtorrent.git
RUN git clone --depth 1 --recurse-submodules -b v${LIBTORRENT_VERSION} ${LIBTORRENT_GIT} .
RUN cmake . -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_INSTALL_PREFIX=/workspace/pkg \
    -DCMAKE_CXX_STANDARD=17 \
    && make -j$(nproc) \
    && make install

FROM alpine:3.14 as qbittorrent_builder

RUN apk add --no-cache boost-dev build-base clang-dev cmake qt5-qtbase-dev qt5-qttools-dev git

COPY --from=libtorrent_builder /workspace/pkg /usr

WORKDIR /workspace

ARG QBITTORRENT_VERSION
ARG QBITTORRENT_GIT=https://github.com/qbittorrent/qBittorrent.git
RUN git clone --depth 1 --recurse-submodules -b release-${QBITTORRENT_VERSION} ${QBITTORRENT_GIT} .
RUN cmake . -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_INSTALL_PREFIX=/workspace/pkg \
    -DCMAKE_CXX_STANDARD=17 \
    -DSTACKTRACE=OFF \
    -DGUI=OFF \
    && make -j$(nproc) \
    && make install

FROM alpine:3.14

RUN apk add --no-cache busybox libgcc openssl qt5-qtbase zlib

COPY --from=qbittorrent_builder /workspace/pkg /usr
COPY --from=libtorrent_builder /workspace/pkg /usr

ADD --chown=1000:100 root /

EXPOSE 6881 6881/udp 8080

ENV QBT_WEBUI_PORT=8080

VOLUME [ "/config", "/downloads" ]

ENTRYPOINT [ "/run.sh" ]

CMD [ "--profile=/" ]
