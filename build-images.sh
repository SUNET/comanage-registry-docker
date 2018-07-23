#!/bin/bash
export COMANAGE_REGISTRY_VERSION="3.1.1"
set -x
set -e

pushd comanage-registry-postgres
docker build --no-cache=true -t docker.sunet.se/comanage-registry-postgres .
popd

docker pull sphericalcowgroup/comanage-registry-slapd-base
pushd comanage-registry-slapd
docker build --no-cache=true -t docker.sunet.se/comanage-registry-slapd .
popd

pushd comanage-registry-shibboleth-sp
sed -e s/%%COMANAGE_REGISTRY_VERSION%%/${COMANAGE_REGISTRY_VERSION}/g Dockerfile.template  > Dockerfile
docker build -t docker.sunet.se/comanage-registry:${COMANAGE_REGISTRY_VERSION}-shibboleth-sp .
popd

pushd comanage-registry-mailman/core
docker build --no-cache=true -t docker.sunet.se/mailman-core:0.1.7 .
popd

pushd comanage-registry-mailman/web
docker build --no-cache=true -t docker.sunet.se/mailman-web:0.1.7 .
popd

pushd comanage-registry-mailman/nginx
docker build --no-cache=true -t docker.sunet.se/mailman-core-nginx .
popd

pushd comanage-registry-mailman/postfix
docker build --no-cache=true -t docker.sunet.se/mailman-postfix .
popd

docker push docker.sunet.se/comanage-registry-postgres:latest
docker push docker.sunet.se/comanage-registry-slapd:latest
docker push docker.sunet.se/comanage-registry:${COMANAGE_REGISTRY_VERSION}-shibboleth-sp
docker push docker.sunet.se/mailman-core:0.1.7
docker push docker.sunet.se/mailman-web:0.1.7
docker push docker.sunet.se/mailman-core-nginx:latest
docker push docker.sunet.se/mailman-postfix:latest
