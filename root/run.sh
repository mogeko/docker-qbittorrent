#!/bin/sh

_command=/usr/bin/qbittorrent-nox
_config_file=/config/qBittorrent.conf
_config_example=/default/qBittorrent.conf

if [ ! -f "${_config_file}" ]; then
    install -p -m 664 "${_config_example}" "${_config_file}"
fi

exec "${_command}" "$@"
