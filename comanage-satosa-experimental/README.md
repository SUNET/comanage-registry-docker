# SATOSA proxy Docker image

Necessary files for building a Docker image for running a
[satosa](https://github.com/its-dirg/satosa) instance.

## Volume binding
All configuration for the proxy in the container by mounting a host directory as
a volume under a directory specified in the environment variable `DATA_DIR` in
the Docker container.
The directory must contain `proxy_conf.yaml`, all enabled plugins, any necessary
signing/encryption keys and all necessary metadata for clients/providers
communicating with the proxy.

It may contain the files `https.{crt,key}`
(private key and certificate for HTTPS), which will then enable HTTPS for the
proxy. If HTTPS is not enabled inside the Docker container, an additional
webserver must be placed in front of the container for SSL/TLS termination since
SATOSA uses a "secure cookie".

**Example of directory structure**

    <host dir>/
    ├── backend.crt
    ├── backend.key
    ├── frontend.crt
    ├── frontend.key
    ├── https.crt
    ├── https.key
    ├── metadata.crt
    ├── metadata.key
    ├── plugins
    │   ├── saml2_backend.py
    │   └── saml2_frontend.py
    ├── proxy_conf.yaml
    └── sp.xml

where

* `{backend, frontend}.{crt, key}` is the cert+key for the SAML SP and IdP of the proxy
* `metadata.{crt, key}` is the cert+key for signing the SAML metadata that is generated
* `{https}.{crt, key}` is the cert+key for HTTPS
* `plugins/saml2_{backend, frontend}.py` is the configuration of the SAML SP and IdP of the proxy
* `proxy_conf.yaml` is the configuration of the proxy
* `sp.xml` is the Service Providers SAML metadata

## Configuration
Instructions for how to configure SATOSA can be found [here](https://github.com/its-dirg/SATOSA/tree/master/doc).

Make sure that the `BASE` parameter in `proxy_conf.yaml` is the publicly
reachable URL (which *must* be HTTPS) of the running Docker container (or
webserver in front of it).

## SAML metadata

The Docker container will create any necessary SAML metadata at startup and
write it to the mounted host directory.

* If the proxy is configured with a SAML frontend, the container will emit
  SAML IdP metadata in the mounted directory. The mounted directory must contain
  the metadata of the SAML Service Providers that will communicate with the
  proxy and the relative path to it must specified in the SAML2 frontend plugin.

* If the proxy is configured with a SAML backend, the container will emit SAML
  SP metadata in the mounted directory. The mounted directory must contain the
  backing IdPs that will provide the authentication and the relative path to it
  must specified in the SAML2 frontend plugin.

## Running a container from the image
```bash
docker run -p <port on host>:<proxy_port> -v <host directory>:<data_dir> -e DATA_DIR=<data_dir> -e PROXY_PORT=<proxy_port> -e SATOSA_STATE_ENCRYPTION_KEY=<secret key> -e SATOSA_USER_ID_HASH_SALT=<secret salt> [-e METADATA_DIR=<metadata_dir>]
itsdirg/satosa
```
