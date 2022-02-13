#!/bin/sh
scriptPath=$(dirname "$(readlink -f "$0")")
source "$scriptPath/.env.sh"

downloadAddr="$KUMA_ADDR:$KUMA_PORT/api/push/$DOWNLOAD_KEY?msg=OK&ping"
uploadAddr="$KUMA_ADDR:$KUMA_PORT/api/push/$UPLOAD_KEY?msg=OK&ping"
latencyAddr="$KUMA_ADDR:$KUMA_PORT/api/push/$LATENCY_KEY?msg=OK&ping"
lossAddr="$KUMA_ADDR:$KUMA_PORT/api/push/$LOSS_KEY?msg=OK&ping"

note=`/usr/bin/speedtest --simple`
URL=$( echo $note | sed 's/.*URL: //' )
download=$( echo $note | sed 's/^.*Download: //; s/ Mbit\/s.*$//' )
upload=$( echo $note | sed 's/^.*Upload: //; s/ Mbit\/s.*$//' )
latency=$( echo $note | sed 's/^.*Ping: //; s/ ms.*$//' )

if [[ $download > $DOWNLOAD_PASS ]]; then
   curl -k -s -o /dev/null "$downloadAddr=$download"
fi

if [[ $upload > $UPLOAD_PASS ]]; then
   curl -k -s -o /dev/null "$uploadAddr=$upload"
fi

if [[ $LATENCY_PASS > $latency ]]; then
   curl -k -s -o /dev/null "$latencyAddr=$latency"
fi
