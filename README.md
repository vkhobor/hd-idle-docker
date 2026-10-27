# hd-idle Docker image

Docker image for running `hd-idle` against host disks.

## Run

```yaml
services:
  hd-idle:
    image: ghcr.io/<owner>/<repo>:latest
    container_name: hd-idle
    restart: unless-stopped
    privileged: true
    volumes:
      - /dev:/dev
      - ./hd-idle-config:/config
```

On first start, the container creates `hd-idle` in the mounted `/config` volume (`./hd-idle-config/hd-idle` on the host), seeded with the package defaults. Defaults spin disks down after 10 minutes of inactivity. Edit that file using the `hd-idle` configuration options, then apply changes with `docker compose restart hd-idle`.

Without a `/config` mount, built-in defaults still work, but edits disappear when the container is recreated.

Equivalent command (replace `/absolute/path`):

```console
docker run -d --name hd-idle --privileged -v /dev:/dev -v /absolute/path/hd-idle-config:/config ghcr.io/<owner>/<repo>:latest
```

## Config file example

```sh
HD_IDLE_OPTS="-i 0 -a /dev/disk/by-uuid/<uuid-of-disk-1> -i 900 -c ata -a /dev/disk/by-uuid/<uuid-of-disk-2> -i 600"
```

This disables spin-down by default, enables it for disk 1 after 900 seconds using ATA commands, and enables it for disk 2 after 600 seconds using the default command type. `-a` names disks for following `-i` settings; hd-idle resolves device symlinks when it starts.

The container must see `/proc/diskstats` and host devices. `privileged: true` with `/dev:/dev` provides this setup; test spin-down on the real host with a real disk.