#!/bin/bash

set -e

CFG_FILE=${CFG_FILE:-/etc/predixy/predixy.conf}

run_predixy() {
    LOG_PATH=${LOG_PATH:-/var/log/predixy}
    LOG_HOME="${LOG_PATH}/$(hostname)"
    mkdir -p "${LOG_HOME}"
    LOG_FILE="${LOG_HOME}/predixy.log"

    nohup predixy ${CFG_FILE} --Log=${LOG_FILE} &> /dev/null &
    tail -F ${LOG_FILE}
}

if [[ -z "$@" ]];then
    echo "Starting predixy ${CFG_FILE} ....."
    run_predixy
else
    echo "Starting exec $@ ......"
    exec "$@"
fi
