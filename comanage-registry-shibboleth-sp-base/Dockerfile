# Dockerfile for Shibboleth SP for COmanage Registry
#
# Portions licensed to the University Corporation for Advanced Internet
# Development, Inc. ("UCAID") under one or more contributor license agreements.
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.
#
# UCAID licenses this file to you under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with the
# License. You may obtain a copy of the License at:
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM debian:buster

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
            apache2 \
            apache2-dev \
            ca-certificates \
            file \
            gcc \
            g++ \
            libboost-dev \
            libcurl4-openssl-dev \
            libssl-dev \
            libssl1.1 \
            make \
            pkg-config \
            wget \
            zlib1g-dev

ARG LOG4SHIB_URL=http://shibboleth.net/downloads/log4shib/2.0.0/log4shib-2.0.0.tar.gz

RUN wget -O log4shib.tar.gz "${LOG4SHIB_URL}" \
      && mkdir -p src \
      && tar -zxf log4shib.tar.gz -C src --strip-components=1 \
      && rm -f log4shib.tar.gz \
      && cd src \
      && LD_FLAGS=-lpthread CXXFLAGS="-fPIC -std=gnu++98" ./configure --disable-static \
            --disable-doxygen \ 
            --prefix=/opt/shibboleth-sp \
            --build=x86_64 \
      && LD_FLAGS=-lpthread make \
      && make -j 2 install \
      && cd .. \
      && rm -r src 

ARG XERCESC_URL=https://apache.cs.utah.edu/xerces/c/3/sources/xerces-c-3.2.3.tar.gz

ARG XERCESC_DIST_URLS="\
    ${XERCESC_URL} \
    https://mirrors.ocf.berkeley.edu/apache/xerces/c/3/sources/xerces-c-3.2.3.tar.gz \
    http://www.gtlib.gatech.edu/pub/apache//xerces/c/3/sources/xerces-c-3.2.3.tar.gz \
    http://apache.mirrors.spacedump.net/xerces/c/3/sources/xerces-c-3.2.3.tar.gz \
    http://apache.mirror.serversaustralia.com.au/xerces/c/3/sources/xerces-c-3.2.3.tar.gz"

RUN for distUrl in ${XERCESC_DIST_URLS}; \
      do \
        if wget -nv -O xerces.tar.gz "${distUrl}"; then \
            break; \
        fi; \
      done \
      && mkdir -p src \
      && tar -zxf xerces.tar.gz -C src --strip-components=1 \
      && rm -f xerces.tar.gz \
      && cd src \
      && CXXFLAGS="-std=gnu++98" ./configure --prefix=/opt/shibboleth-sp \
      && make -j 2 \
      && make install \
      && cd .. \
      && rm -r src 

ARG XMLSECC_URL=https://apache.cs.utah.edu/santuario/c-library/xml-security-c-2.0.2.tar.gz

ARG XMLSECC_DIST_URLS="\
    ${XMLSECC_DIST_URLS} \
    https://mirrors.ocf.berkeley.edu/apache/santuario/c-library/xml-security-c-2.0.2.tar.gz \
    http://www.gtlib.gatech.edu/pub/apache/santuario/c-library/xml-security-c-2.0.2.tar.gz \
    http://apache.mirrors.spacedump.net/santuario/c-library/xml-security-c-2.0.2.tar.gz \
    http://apache.mirror.serversaustralia.com.au/santuario/c-library/xml-security-c-2.0.2.tar.gz" 

RUN for distUrl in ${XMLSECC_DIST_URLS}; \
      do \
        if wget -nv -O xmlsecc.tar.gz "${distUrl}"; then \
            break; \
        fi; \
      done \
      && mkdir -p src \
      && tar -zxf xmlsecc.tar.gz -C src --strip-components=1 \
      && rm -f xmlsecc.tar.gz \
      && cd src \
      && CXXFLAGS="-std=gnu++98" PKG_CONFIG_PATH=/opt/shibboleth-sp/lib/pkgconfig ./configure --prefix=/opt/shibboleth-sp \
            --with-openssl=/usr \
            --disable-static \
            --without-xalan \
      && make -j 2 \
      && make install \
      && cd .. \
      && rm -r src 

ARG XMLTOOLING_URL=http://shibboleth.net/downloads/c++-opensaml/3.1.0/xmltooling-3.1.0.tar.gz

RUN wget -O xmltooling.tar.gz "${XMLTOOLING_URL}" \
      && mkdir -p src \
      && tar -zxf xmltooling.tar.gz -C src --strip-components=1 \
      && rm -f xmltooling.tar.gz \
      && cd src \
      && CXXFLAGS="-fPIC -std=gnu++98" \
            PKG_CONFIG_PATH=/opt/shibboleth-sp/lib/pkgconfig \
            ./configure --prefix=/opt/shibboleth-sp \
            --with-log4shib=/opt/shibboleth-sp \
            -C \
      && make -j 2 \
      && make install \
      && cd .. \
      && rm -r src 

ARG OPENSAMLC_URL=http://shibboleth.net/downloads/c++-opensaml/3.1.0/opensaml-3.1.0.tar.gz

RUN wget -O opensamlc.tar.gz "${OPENSAMLC_URL}" \
      && mkdir -p src \
      && tar -zxf opensamlc.tar.gz -C src --strip-components=1 \
      && rm -f opensamlc.tar.gz \
      && cd src \
      && CXXFLAGS="-std=gnu++98" \
            PKG_CONFIG_PATH=/opt/shibboleth-sp/lib/pkgconfig \
            ./configure --prefix=/opt/shibboleth-sp \
            --with-log4shib=/opt/shibboleth-sp \
            -C \
      && make -j 2 \
      && make install \
      && cd .. \
      && rm -r src 

ARG SHIBBOLETH_SP_URL=http://shibboleth.net/downloads/service-provider/3.1.0/shibboleth-sp-3.1.0.tar.gz

RUN wget -O shibboleth-sp.tar.gz "${SHIBBOLETH_SP_URL}" \
      && mkdir -p src \
      && tar -zxf shibboleth-sp.tar.gz -C src --strip-components=1 \
      && rm -f shibboleth-sp.tar.gz \
      && cd src \
      && CXXFLAGS="-std=gnu++98 -Wno-unused-parameter" \
            PKG_CONFIG_PATH=/opt/shibboleth-sp/lib/pkgconfig \
            ./configure --prefix=/opt/shibboleth-sp \
            --with-log4shib=/opt/shibboleth-sp \
            --with-saml=/opt/shibboleth-sp \
            --with-xerces=/opt/shibboleth-sp \
            --with-xmlsec=/opt/shibboleth-sp \
            --with-xmltooling=/opt/shibboleth-sp \
            --enable-apache-24 \
            --with-apxs24=/usr/bin/apxs \
            --disable-adfs \
            --disable-obc \
      && make -j 2 \
      && make install \
      && cd .. \
      && rm -r src 

COPY shib2.load /opt/shibboleth-sp/etc/shibboleth/shib2.load
COPY shibboleth2.xml.template /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml.template
COPY shibd.logger /opt/shibboleth-sp/etc/shibboleth/shibd.logger
COPY native.logger /opt/shibboleth-sp/etc/shibboleth/native.logger
COPY console.logger /opt/shibboleth-sp/etc/shibboleth/console.logger

RUN apt-get update && apt-get install -y \
      && apt-get purge -y \
         apache2-dev \
         file \
         gcc \
         g++ \
         libboost-dev \
         libcurl4-openssl-dev \
         libssl-dev \
         make \
         pkg-config \
      && apt-get clean
