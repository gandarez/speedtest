FROM alpine:3

LABEL MAINTAINER="Carlos Henrique Guardão Gandarez <gandarez@gmail.com>"

ENV TAR_FILE="https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-armhf-linux.tgz"

RUN apk add --update --no-cache \
    curl ca-certificates coreutils jq && \
    mkdir /ookla-speedtest && \
    curl -L ${TAR_FILE} | tar xvz -C /ookla-speedtest && \
    mv /ookla-speedtest/speedtest /usr/bin/speedtest && \
    chmod +x /usr/bin/speedtest && \
    rm -rf /ookla-speedtest && \
    rm -f /var/cache/apk/*

WORKDIR /app

COPY run.sh ./

RUN chmod a+x run.sh

CMD ["/app/run.sh"]
