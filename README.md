# docker-qbittorrent

[![ci_icon]][ci_link]

Docker image for qBittorrent. 

## Usage

Pull this image:

```shell
docker pull ghcr.io/mogeko/qbittorrent:edge
```

Run with docker cli:

```shell
docker run -d \
  --name qbittorrent \
  -e QBT_WEBUI_PORT=8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -p 8080:8080 \
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
    environment:
      - QBT_WEBUI_PORT=8080
    volumes:
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
| `-v /downloads`          | Location of downloads on disk |

The `qbittorrent-nox`'s options may be supplied via environment variables[^1]. For option named 'parameter-name', environment variable name is `QBT_PARAMETER_NAME` (in uppercase, `-` replaced with `_`). To pass flag values, set the variable to `1` or `TRUE`. Here is an example we already in used: `-e QBT_WEBUI_PORT=8080`.

More help message about `qbittorrent-nox`, you can get via:

```shell
docker run -it ghcr.io/mogeko/qbittorrent:edge --help
```

## License

The code in this project is released under the [GPL-3.0 License][license].


<!-- footnote -->

[^1]: The option `QBT_PROFILE` does not support.

<!-- badge -->

[ci_icon]: https://github.com/mogeko/docker-qbittorrent/actions/workflows/auto-update.yml/badge.svg
[ci_link]: https://github.com/mogeko/docker-qbittorrent/actions/workflows/auto-update.yml

<!-- links -->

[docker-compose]: https://docs.docker.com/compose
[license]: https://github.com/mogeko/docker-qbittorrent/blob/master/LICENSE
