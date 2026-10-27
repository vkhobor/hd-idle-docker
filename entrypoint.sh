#!/bin/sh
set -eu
set -f   # don't glob-expand the options string

BIN=/usr/local/bin/hd-idle

if [ "$#" -gt 0 ]; then
    exec "$BIN" "$@"
fi

# shellcheck disable=SC2086
exec "$BIN" ${HD_IDLE_OPTS:-}
