# speedtest

[![Docker Stars](https://img.shields.io/docker/stars/gandarez/speedtest.svg)](https://hub.docker.com/r/gandarez/speedtest/)
[![Docker Pulls](https://img.shields.io/docker/pulls/gandarez/speedtest.svg)](https://hub.docker.com/r/gandarez/speedtest/)
[![ImageLayers](https://images.microbadger.com/badges/image/gandarez/speedtest.svg)](https://microbadger.com/#/images/gandarez/speedtest)

sppedtest tests your internet connection using cli provided by Ookla.

## Quick Start

Run docker with a mounted volume:

```bash
docker run --rm -ti -v `pwd`/results:/app/results gandarez/speedtest
```

> Alternatively provide a specific server id by setting an environment variable `OOKLA_SERVER_ID`.

```bash
docker run --rm -ti -e OOKLA_SERVER_ID=<id> -v `pwd`/results:/app/results gandarez/speedtest
```

Every run you'll get a raw json file and a consolidated csv file.

## Cron Job

Better to keep tracking your internet speed by running it indeterminately as a cron job. Edit your cron by running `crontab -e` and add the following:

```bash
*/30 * * * * docker run --rm -v /path/to/results:/app/results -v /etc/localtime:/etc/localtime:ro gandarez/speedtest
```

## Contributing

Any comment, bug report and pull request are more than welcome.

Made with :heart: by Gandarez
