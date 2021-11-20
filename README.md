# docker-qbittorrent

[![ci_icon]][ci_link] [![image_size]][docker_link] [![image_ver]][docker_link] [![unstable_ver]][docker_link]

Docker image for qBittorrent. 

- Tiny size
- Enable rootless[^1]
- Enable `QBT_*` options[^2]
- Keep updating
- Compile by `clang`

## Usage

Pull this image:

```shell
docker pull ghcr.io/mogeko/qbittorrent
```

Run with docker cli:

```shell
docker run -d \
  --name qbittorrent \
  --user 1000:100 `#optional` \
  -e QBT_WEBUI_PORT=8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -p 8080:8080 \
  -v /path/to/config:/config \
  -v /path/to/downloads:/downloads \
  --restart unless-stopped \
  ghcr.io/mogeko/qbittorrent
```

Run with [docker-compose]:

```yml
---
version: 2.1
services:
  qbittorrent:
    image: ghcr.io/mogeko/qbittorrent
    container_name: qbittorrent
    user: 1000:100 #optional
    environment:
      - QBT_WEBUI_PORT=8080
    volumes:
      - /path/to/config:/config
      - /path/to/downloads:/downloads
    ports:
      - 6881:6881
      - 6881:6881/udp
      - 8080:8080
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter                | Function                      |
|--------------------------|-------------------------------|
| `-p 6881`                | tcp connection port           |
| `-p 6881/udp`            | udp connection port           |
| `-p 8080`                | The Web UI port               |
| `-e QBT_WEBUI_PORT=8080` | Change the Web UI port        |
| `-v /config`             | Save the configuration files  |
| `-v /downloads`          | Location of downloads on disk |

The `qbittorrent-nox`'s options may be supplied via environment variables[^2]. For option named 'parameter-name', environment variable name is `QBT_PARAMETER_NAME` (in uppercase, `-` replaced with `_`). To pass flag values, set the variable to `1` or `TRUE`. Here is an example we already in used: `-e QBT_WEBUI_PORT=8080`.

More help message about `qbittorrent-nox`, you can get via:

```shell
docker run -it ghcr.io/mogeko/qbittorrent --help
```

## License

The code in this project is released under the [GPL-3.0 License][license].


<!-- footnote -->

[^1]: This image should be able to work with [podman], but it has not been tested.
[^2]: The option `QBT_PROFILE` does not support.

<!-- badge -->

[ci_icon]: https://github.com/mogeko/docker-qbittorrent/actions/workflows/auto-update.yml/badge.svg
[ci_link]: https://github.com/mogeko/docker-qbittorrent/actions/workflows/auto-update.yml
[image_size]: https://img.shields.io/docker/image-size/mogeko/qbittorrent?logo=docker
[image_ver]: https://img.shields.io/docker/v/mogeko/qbittorrent/latest?logo=docker
[unstable_ver]: https://img.shields.io/docker/v/mogeko/qbittorrent?label=unstable%20version&logo=docker
[docker_link]: https://hub.docker.com/r/mogeko/qbittorrent

<!-- links -->

[docker-compose]: https://docs.docker.com/compose
[license]: https://github.com/mogeko/docker-qbittorrent/blob/master/LICENSE
[podman]: https://podman.io
