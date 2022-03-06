#!/bin/sh
scriptPath=$(dirname "$(readlink -f "$0")")
source "$scriptPath/.env.sh"

download=""
upload=""
latency=""
timestamp=""
timestring=""
if [[ -n "$SPEEDTEST_ADDR" && -n "$SPEEDTEST_PORT" ]]; then #if user set an address from speedtest-tracker, use the results from that
   latest_speedtest=$(curl --silent -X GET $SPEEDTEST_ADDR:$SPEEDTEST_PORT/api/speedtest/latest)
   download=$( echo "$latest_speedtest" | jq '.["data"]["download"]' | bc)
   upload=$( echo "$latest_speedtest" | jq '.["data"]["upload"]'  | bc)
   latency=$( echo "$latest_speedtest" | jq '.["data"]["ping"]' | bc)
   timestamp=$( echo "$latest_speedtest" | jq '.["data"]["created_at"]' | bc)
   timestring="Speedtest-Tracker+Test+Time+-+$timestamp"
else #if user isnt running speedtest-tracker, run our own speedtest
   note=`/usr/bin/speedtest --simple`
   URL=$( echo $note | sed 's/.*URL: //' )
   download=$( echo $note | sed 's/^.*Download: //; s/ Mbit\/s.*$//' )
   upload=$( echo $note | sed 's/^.*Upload: //; s/ Mbit\/s.*$//' )
   latency=$( echo $note | sed 's/^.*Ping: //; s/ ms.*$//' )
   timestamp=`date "+%Y-%m-%dT%H:%M:%S"`
   timestring="Ursa+Test+Time+-+$timestamp"
fi

downloadAddr="$KUMA_ADDR:$KUMA_PORT/api/push/$DOWNLOAD_KEY?msg=$timestring&ping"
uploadAddr="$KUMA_ADDR:$KUMA_PORT/api/push/$UPLOAD_KEY?msg=$timestring&ping"
latencyAddr="$KUMA_ADDR:$KUMA_PORT/api/push/$LATENCY_KEY?msg=$timestring&ping"
lossAddr="$KUMA_ADDR:$KUMA_PORT/api/push/$LOSS_KEY?msg=$timestring&ping"

if [[ 1 -eq "$(echo "${download} > ${DOWNLOAD_PASS}" | bc)" ]]; then
   curl -k -s -o /dev/null "$downloadAddr=$download"
fi

if [[ 1 -eq "$(echo "${upload} > ${UPLOAD_PASS}" | bc)" ]]; then
   curl -k -s -o /dev/null "$uploadAddr=$upload"
fi

if [[ 1 -eq "$(echo "${LATENCY_PASS} > ${latency}" | bc)" ]]; then
   curl -k -s -o /dev/null "$latencyAddr=$latency"
fi
