# speedtest-ursa(minor)
[![Docker pulls](https://img.shields.io/docker/pulls/mtg1555/speedtest-ursa-minor?style=flat-square)](https://hub.docker.com/r/mtg1555/speedtest-ursa-minor)

Small service app for pushing speedtest results to [Uptime Kuma ](https://github.com/louislam/uptime-kuma).

This program allows you to schedule speedtests, define upload/download/ping thresholds that must be met for your network to be considered "up", and report the results to push monitors in [Uptime Kuma ](https://github.com/louislam/uptime-kuma). It also allows you to forward speedtest results from the [Speedtest-Tracker](https://github.com/henrywhitaker3/Speedtest-Tracker) API to Update Kuma as well.

## Usage

### docker-compose (recommended, [click here for more info](https://docs.linuxserver.io/general/docker-compose))

```yml
version: '3'
services:
  ursa:
    image: mtg1555/speedtest-ursa-minor
    container_name: speedtest-ursa-minor
    environment:
      - "SPEEDTEST_SCHEDULE=0 * * * *"
      - DOWNLOAD_KEY=<kuma-push-key-1>
      - UPLOAD_KEY=<kuma-push-key-2>
      - LATENCY_KEY=<kuma-push-key-3>
    restart: unless-stopped
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

A docker image is available [here](https://hub.docker.com/r/mtg1555/speedtest-ursa-minor), you can create a new conatiner by running:

```bash
docker run \
      --name=ursa \
      --restart unless-stopped \
      -e "SPEEDTEST_SCHEDULE=0 * * * *" \
      -e DOWNLOAD_KEY=<kuma-push-key-1> \
      -e UPLOAD_KEY=<kuma-push-key-2> \
      -e LATENCY_KEY=<kuma-push-key-3> \
      mtg1555/speedtest-ursa-minor
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-e DOWNLOAD_PASS=0` | Minimum download Mbps returned by the speedtest for your network to be considered "up" |
| `-e UPLOAD_PASS=0` | Minimum upload Mbps returned by the speedtest for your network to be considered "up" |
| `-e LATENCY_PASS=10000` | Maximum latency ms returned by the speedtest for your network to be considered "up" |
| `-e "SPEEDTEST_SCHEDULE=0 * * * *"` | Cron expression for how often to run speedtests |
| `-e KUMA_ADDR=localhost` | the ip address that Uptime Kuma listens on |
| `-e KUMA_PORT=3001` | The port that Uptime Kuma listens on |
| `-e SPEEDTEST_ADDR=` | (OPTIONAL) the ip address of the Speedtest-Tracker API to forward results from |
| `-e SPEEDTEST_ADDR=` | (OPTIONAL) the port of the Speedtest-Tracker API to forward results from |
| `-e DOWNLOAD_KEY=""` | (REQUIRED) The key in the push url for the push monitor tracking download uptime |
| `-e UPLOAD_KEY=""` | (REQUIRED) The key in the push url for the push monitor tracking upload uptime |
| `-e LATENCY_KEY=""` | (REQUIRED) The key in the push url for the push monitor tracking latency uptime |

