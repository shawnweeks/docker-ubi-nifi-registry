#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

# Get Hostname from EC2 Meta if running on AWS ECS EC2
if [[ "${AWS_EXECUTION_ENV:=FALSE}" == "AWS_ECS_EC2" ]]
then
    export AWS_EC2_HOSTNAME="$(curl -s 169.254.169.254/latest/meta-data/local-hostname)"
fi

export JAVA_OPTS="${JAVA_OPTS}"

shutdown() {
    echo "NiFi-Registry Shutting Down"
    kill -SIGTERM ${NIFI_REGISTRY_PID}
    echo "NiFi-Registry Shut Down"
}


entrypoint.py

# Clears variables starting with NIFI_ to avoid any secret leakage.
unset "${!NIFI_REGISTRY_@}"

trap "shutdown" TERM

bin/nifi-registry.sh run &
NIFI_REGISTRY_PID="$!"

echo "NiFi-Registry running with PID ${NIFI_REGISTRY_PID}"
wait ${NIFI_REGISTRY_PID}