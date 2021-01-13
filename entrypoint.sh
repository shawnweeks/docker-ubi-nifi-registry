#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

# Get Hostname from EC2 Meta if running on AWS ECS EC2
if [[ "${AWS_EXECUTION_ENV:=FALSE}" == "AWS_ECS_EC2" ]]
then
    export HOSTNAME="$(curl -s 169.254.169.254/latest/meta-data/local-hostname)"
fi

export JAVA_OPTS="${JAVA_OPTS}"

entrypoint.py

# Clears variables starting with NIFI_ to avoid any secret leakage.
unset "${!NIFI_REGISTRY_@}"

bin/nifi-registry.sh run