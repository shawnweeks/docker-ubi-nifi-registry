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

entrypoint.py

# Clears variables starting with NIFI_ to avoid any secret leakage.
unset "${!NIFI_REGISTRY_@}"

set +e
flock -x -w 30 ${HOME}/.flock ${HOME}/bin/nifi-registry.sh run &
NIFI_REGISTRY_PID="$!"

echo "NiFi-Registry Started with PID ${NIFI_REGISTRY_PID}"
wait ${NIFI_REGISTRY_PID}

if [[ $? -eq 1 ]]
then
    echo "NiFi-Registry Failed to Aquire Lock! Exiting"
    exit 1
fi
