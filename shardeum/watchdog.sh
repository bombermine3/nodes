#!/bin/bash

lock_file='watchdog.lock'

lock() { [ -f $lock_file ] && exit || touch $lock_file ; }
unlock() { rm $lock_file ; }
get_status() { docker exec -t shardeum-dashboard operator-cli status | sed -ne 's/state: \(.*\)/\1/p' | tr -d "\n\r" ; }
start_shardeum() { docker exec -t shardeum-dashboard operator-cli start ; }
log_time() { date '+%Y-%m-%d %H:%M:%S' ; }

cd "${0%/*}"

lock

while [ $(get_status) = 'stopped' ]; do
        echo $(log_time) 'Shardeum is stopped. Trying to start'
        start_shardeum
        sleep 15
done

echo $(log_time) 'Shardeum is started'
unlock
