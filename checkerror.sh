#!/bin/bash

# not support set command, if set 'set -ex', the probe will always be failed.
# also you can see this post, and all command write into livenessProbe.exec.command section
# https://stackoverflow.com/questions/69724351/kubernetes-liveness-probe-exec-command-environment-variables-in-an-if-statement

TAIL_NUM=${TAIL_NUM:-20}
LOG_PATH=${LOG_PATH:-/var/log/predixy}
LOG_FILE="${LOG_PATH}/$(hostname)/predixy.log"

ERR=$(tail -${TAIL_NUM} ${LOG_FILE} | grep -c 'EventError')

if [[ "x${ERR}" != "x0" ]]; then
    MSG="WARNING: Catch $ERR times EventError. Infer backend has changed and is about to restart!"
    echo "${MSG}" | tee -a ${LOG_FILE}
    exit 1
fi

exit 0
