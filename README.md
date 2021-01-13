### Download Packages
```shell
export NIFI_REGISTRY_VERSION=0.8.0
wget https://archive.apache.org/dist/nifi/nifi-registry/nifi-registry-${NIFI_REGISTRY_VERSION}/nifi-registry-${NIFI_REGISTRY_VERSION}-bin.tar.gz
```

### Build Command
```shell
export NIFI_REGISTRY_VERSION=0.8.0
docker build \
    -t ${REGISTRY}/apache/nifi-registry:${NIFI_REGISTRY_VERSION} \
    --build-arg BASE_REGISTRY=$REGISTRY \
    --build-arg NIFI_REGISTRY_VERSION=${NIFI_REGISTRY_VERSION} \
    .
```

### Push to Registry
```shell
export NIFI_REGISTRY_VERSION=0.8.0
docker push ${REGISTRY}/apache/nifi-registry:${NIFI_REGISTRY_VERSION}
```

### Simple Run Command
```shell
export NIFI_REGISTRY_VERSION=0.8.0
docker run --init -it --rm \
    --name nifi-registry  \
    -p 18080:18080 \
    ${REGISTRY}/apache/nifi-registry:${NIFI_REGISTRY_VERSION}
```