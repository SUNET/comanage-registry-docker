FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        python3-dev \
        build-essential \
        python3-pip \
        libffi-dev \
        libssl-dev \
        xmlsec1 \
        libyaml-dev \
        wget

# Build from SATOSA PR 233 until the PR is merged.
ENV SATOSA_PIP_TARGET=git+git://github.com/IdentityPython/SATOSA.git@refs/pull/233/merge

RUN pip3 install --upgrade pip setuptools
RUN pip3 install ldap3
RUN pip3 install ${SATOSA_PIP_TARGET}

COPY start.sh /tmp/satosa/start.sh
COPY attributemaps /tmp/satosa/attributemaps
ENTRYPOINT ["/tmp/satosa/start.sh"]
