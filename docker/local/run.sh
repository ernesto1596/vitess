#!/bin/bash

podman run \
    -p 15000:15000 \
    -p 15001:15001 \
    -p 15991:15991 \
    -p 15999:15999 \
    -p 16000:16000 \
    --rm \
    --privileged \
    --mount type=bind,source=/home/ernestoc/sources/github/vitess,target=/vt/local/host \
    -it vitess/local \
