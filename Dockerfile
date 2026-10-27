FROM debian:stable-slim AS package

ARG TARGETARCH
ARG TARGETVARIANT

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# renovate: datasource=github-releases depName=adelolmo/hd-idle versioning=loose
ARG VERSION=1.21

RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) deb_arch=amd64 ;; \
      arm64) deb_arch=arm64 ;; \
      arm) [ "$TARGETVARIANT" = v7 ] && deb_arch=armhf || { echo "Unsupported ARM variant: ${TARGETVARIANT:-unset}" >&2; exit 1; } ;; \
      *) echo "Unsupported Docker architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac; \
    mkdir -p /tmp/package; \
    curl -fsSL "https://github.com/adelolmo/hd-idle/releases/download/v${VERSION}/hd-idle_${VERSION}_${deb_arch}.deb" -o /tmp/hd-idle.deb; \
    dpkg-deb -x /tmp/hd-idle.deb /tmp/package; \
    find /tmp/package -type f -print; \
    test -f /tmp/package/usr/sbin/hd-idle

FROM debian:stable-slim

LABEL org.opencontainers.image.source="https://github.com/vkhobor/hd-idle-docker" \
      org.opencontainers.image.description="Docker image packaging hd-idle" \
      org.opencontainers.image.licenses="GPL-3.0"

COPY --from=package /tmp/package/usr/sbin/hd-idle /usr/local/bin/hd-idle
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]