#!/bin/sh
echo "Starting speedcheck cron"
scriptPath=$(dirname "$(readlink -f "$0")")

printenv | sed 's/\(=[[:blank:]]*\)\(.*\)/\1"\2"/' | sed 's/^\(.*\)$/export \1/g' > ${scriptPath}/.env.sh
chmod +x ${scriptPath}/.env.sh

/usr/sbin/crond -f