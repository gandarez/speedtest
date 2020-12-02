FROM alpine:3

ENV TAR_FILE="https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-i386-linux.tgz"

RUN apk add --update --no-cache \
    curl ca-certificates coreutils jq && \
    mkdir /ookla-speedtest && \
    curl -L ${TAR_FILE} | tar xvz -C /ookla-speedtest && \
    mv /ookla-speedtest/speedtest /usr/bin/speedtest && \
    chmod +x /usr/bin/speedtest && \
    rm -rf /ookla-speedtest && \
    apk del curl && \
    rm -f /var/cache/apk/*

WORKDIR /app

COPY run.sh ./

RUN chmod a+x run.sh

CMD ["/app/run.sh"]
