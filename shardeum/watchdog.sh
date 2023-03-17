#!/bin/bash

lock_file='watchdog.lock'

get_status() { docker exec -t shardeum-dashboard operator-cli status | sed -ne 's/state: \(.*\)/\1/p' | tr -d '\n\r' ; }
start_shardeum() { docker exec -t shardeum-dashboard operator-cli start ; }
log_time() { date '+%Y-%m-%d %H:%M:%S' ; }

cd "${0%/*}"

if { set -C; 2>/dev/null >$lock_file; }; then
    trap "rm -f $lock_file" EXIT
else
    exit
fi

while [ $(get_status) = 'stopped' ]; do
    echo $(log_time) 'Shardeum is stopped. Trying to start'
    start_shardeum
    sleep 15
done

echo $(log_time) 'Shardeum is started'
