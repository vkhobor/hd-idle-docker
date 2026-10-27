# hd-idle Docker image

Docker image for running `hd-idle` against host disks. Configure options with `HD_IDLE_OPTS`.

## Run

Pull image:

```console
docker pull ghcr.io/vkhobor/hd-idle-docker:latest
```

```yaml
services:
  hd-idle:
    image: ghcr.io/vkhobor/hd-idle-docker:latest
    container_name: hd-idle
    restart: unless-stopped
    privileged: true
    environment:
      HD_IDLE_OPTS: "-i 0 -a /dev/disk/by-uuid/<uuid-of-disk-1> -i 900 -c ata -a /dev/disk/by-uuid/<uuid-of-disk-2> -i 600"
    volumes:
      - /dev:/dev
```

`HD_IDLE_OPTS` passes options directly to `hd-idle`. This example disables spin-down by default, enables it for disk 1 after 900 seconds using ATA commands, and enables it for disk 2 after 600 seconds using the default command type. `-a` names disks for following `-i` settings; `hd-idle` resolves device symlinks when it starts.

Apply option changes by restarting the container:

```console
docker compose restart hd-idle
```

Equivalent command:

```console
docker run -d --name hd-idle --privileged \
  -e 'HD_IDLE_OPTS=-i 0 -a /dev/disk/by-uuid/<uuid-of-disk-1> -i 900 -c ata -a /dev/disk/by-uuid/<uuid-of-disk-2> -i 600' \
  -v /dev:/dev ghcr.io/vkhobor/hd-idle-docker:latest
```

The container must see `/proc/diskstats` and host devices. `privileged: true` with `/dev:/dev` provides this setup; test spin-down on the real host with a real disk.