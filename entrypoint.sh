#!/bin/sh
# Runs as root at container start (see Dockerfile's final USER root). Remaps the
# `dev` user's UID/GID to match the host user before dropping privileges, so
# anything the container writes into a bind-mounted host directory (/workspace,
# and ~/.ssh if it were writable) shows up owned by the actual host user instead
# of an arbitrary container UID. The `dev` launcher script passes HOST_UID/GID in;
# default to 1000:1000 (the image's build-time default, and the common first-user
# UID on most Linux desktops) if run without it — e.g. via a bare `docker run`.
set -e

HOST_UID="${HOST_UID:-1000}"
HOST_GID="${HOST_GID:-1000}"

CURRENT_UID="$(id -u dev)"
CURRENT_GID="$(id -g dev)"

if [ "$CURRENT_GID" != "$HOST_GID" ]; then
    groupmod -o -g "$HOST_GID" dev
fi

if [ "$CURRENT_UID" != "$HOST_UID" ]; then
    usermod -o -u "$HOST_UID" dev
fi

if [ "$CURRENT_UID" != "$HOST_UID" ] || [ "$CURRENT_GID" != "$HOST_GID" ]; then
    # Home dir content was created at build time under the old UID/GID (build
    # args DEV_UID/DEV_GID) — fix it up so it's not left "orphaned" after the
    # remap above. /workspace is a bind mount and already reflects the host's
    # real ownership, so it's deliberately not touched here.
    chown -R dev:dev /home/dev
fi

exec su-exec dev "$@"
