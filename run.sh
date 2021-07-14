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

if [ ${FEED_ID+x} ] && [ ${API_KEY+x} ]; then
  echo "pushing results to http://iotplotter.com/api/v2/feed/${FEED_ID}"

  PING=$(cat $JSON | jq .ping.latency)
  DOWNLOAD=$(($(cat $JSON | jq .download.bandwidth) * 8 / 1000))
  UPLOAD=$(($(cat $JSON | jq .upload.bandwidth) * 8 / 1000))

  curl -H "api-key: ${API_KEY}" \
    -d "{\"data\": {\"Ping\": [{\"value\": ${PING}}], \"Download\": [{\"value\": ${DOWNLOAD}}], \"Upload\": [{\"value\": ${UPLOAD}}]}}" \
    http://iotplotter.com/api/v2/feed/${FEED_ID}
fi
