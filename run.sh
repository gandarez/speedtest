#!/bin/sh

set -eu

RESULTS_DIR=$PWD/results
mkdir -p $RESULTS_DIR
NOW=`date -u`
FILE=`date -d "$NOW" +%Y%m%d%H%M%S`
CSV=$RESULTS_DIR/results.csv
JSON=$RESULTS_DIR/$FILE.json

if ! [ -f $CSV ]; then
    echo "timestamp,server name,server id,latency,jitter,packet loss,download,upload,download bytes,upload bytes,share url" > $CSV
fi

if [ -z ${OOKLA_SERVER_ID+x} ]; then
  RESULT=$(speedtest -f json-pretty --accept-license --accept-gdpr)
else
  RESULT=$(speedtest -s ${OOKLA_SERVER_ID} -f json-pretty --accept-license --accept-gdpr)
fi

# save it to raw json
echo $RESULT | jq > $JSON
# consolidate it to csv file
echo $RESULT | jq -r '[.timestamp,.server.name,.server.id,.ping.latency,.ping.jitter,.packetLoss,.download.bandwidth,.upload.bandwidth,.download.bytes,.upload.bytes,.result.url] | @csv' >> $CSV
