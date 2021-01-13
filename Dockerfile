ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi8
ARG BASE_TAG=8.3

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as build

ARG NIFI_REGISTRY_VERSION
ARG NIFI_REGISTRY_PACKAGE=nifi-registry-${NIFI_REGISTRY_VERSION}-bin.tar.gz

COPY [ "${NIFI_REGISTRY_PACKAGE}", "/tmp/" ]

RUN mkdir -p /tmp/nifi_registry_package && \
    tar -xf /tmp/${NIFI_REGISTRY_PACKAGE} -C "/tmp/nifi_registry_package" --strip-components=1 && \
    mkdir -p /tmp/nifi_registry_package/conf && \
    mkdir -p /tmp/nifi_registry_package/flow_storage && \
    mkdir -p /tmp/nifi_registry_package/database && \
    mkdir -p /tmp/nifi_registry_package/work && \
    mkdir -p /tmp/nifi_registry_package/logs && \
    mkdir -p /tmp/nifi_registry_package/run

###############################################################################
ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi8
ARG BASE_TAG=8.3

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV NIFI_REGISTRY_USER nifi-registry
ENV NIFI_REGISTRY_GROUP nifi-registry
ENV NIFI_REGISTRY_UID 2002
ENV NIFI_REGISTRY_GID 2002

ENV NIFI_REGISTRY_HOME /opt/nifi-registry

RUN yum install -y java-11-openjdk-devel python2 python2-jinja2 && \
    yum clean all && \
    mkdir -p ${NIFI_REGISTRY_HOME} && \    
    groupadd -r -g ${NIFI_REGISTRY_GID} ${NIFI_REGISTRY_GROUP} && \
    useradd -r -u ${NIFI_REGISTRY_UID} -g ${NIFI_REGISTRY_GROUP} -M -d ${NIFI_REGISTRY_HOME} ${NIFI_REGISTRY_USER} && \
    chown ${NIFI_REGISTRY_USER}:${NIFI_REGISTRY_GROUP} ${NIFI_REGISTRY_HOME}

COPY [ "templates/*.j2", "/opt/jinja-templates/" ]
COPY --from=build --chown=${NIFI_REGISTRY_USER}:${NIFI_REGISTRY_GROUP} [ "/tmp/nifi_registry_package", "${NIFI_REGISTRY_HOME}/" ]
COPY --chown=${NIFI_REGISTRY_USER}:${NIFI_REGISTRY_GROUP} [ "entrypoint.sh", "entrypoint.py", "entrypoint_helpers.py", "${NIFI_REGISTRY_HOME}/" ]

RUN chmod 755 ${NIFI_REGISTRY_HOME}/entrypoint.*

EXPOSE 18080

VOLUME ${NIFI_REGISTRY_HOME}/conf
VOLUME ${NIFI_REGISTRY_HOME}/flow_storage
VOLUME ${NIFI_REGISTRY_HOME}/database
VOLUME ${NIFI_REGISTRY_HOME}/work
VOLUME ${NIFI_REGISTRY_HOME}/logs
VOLUME ${NIFI_REGISTRY_HOME}/run

USER ${NIFI_REGISTRY_USER}
ENV JAVA_HOME=/usr/lib/jvm/java-11
ENV PATH=${PATH}:${NIFI_REGISTRY_HOME}
WORKDIR ${NIFI_REGISTRY_HOME}
ENTRYPOINT [ "entrypoint.sh" ]