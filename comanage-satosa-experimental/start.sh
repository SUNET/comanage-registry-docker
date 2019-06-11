#!/usr/bin/env bash

# for Click library to work in satosa-saml-metadata
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# exit immediately on failure
set -e

DATA_DIR=${DATA_DIR-/etc/satosa}
METADATA_DIR=${METADATA_DIR-"${DATA_DIR}"}
PROXY_PORT=${PROXY_PORT-8000}

# Gunicorn options
WORKERS=${WORKERS-4}
WORKER_CLASS=${WORKER_CLASS-sync}
WORKER_THREADS=${WORKER_THREADS-1}
WORKER_TIMEOUT=${WORKER_TIMEOUT-60}

if [ ! -d "${DATA_DIR}" ]; then
   mkdir -p "${DATA_DIR}"
fi

cd ${DATA_DIR}

mkdir -p ${METADATA_DIR}

if [ ! -d ${DATA_DIR}/attributemaps ]; then
   cp -pr /tmp/satosa/attributemaps ${DATA_DIR}/attributemaps
fi


# generate metadata for front- (IdP) and back-end (SP) and write it to mounted volume

#satosa-saml-metadata proxy_conf.yaml ${DATA_DIR}/metadata.key ${DATA_DIR}/metadata.crt --dir ${METADATA_DIR}

# start the proxy
if [[ -f https.key && -f https.crt ]]; then # if HTTPS cert is available, use it
  exec gunicorn --reload --bind 0.0.0.0:${PROXY_PORT} --keyfile https.key --certfile https.crt \
      --workers ${WORKERS} --worker-class ${WORKER_CLASS} --threads ${WORKER_THREADS} \
      --timeout ${WORKER_TIMEOUT} satosa.wsgi:app
else
  exec gunicorn --bind 0.0.0.0:${PROXY_PORT} --workers ${WORKERS} --worker-class ${WORKER_CLASS} \
      --threads ${WORKER_THREADS} --timeout ${WORKER_TIMEOUT} satosa.wsgi:app
fi
