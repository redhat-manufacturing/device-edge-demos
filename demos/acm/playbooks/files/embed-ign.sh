#!/bin/bash

function coreos-installer {
    cluster_dir="$1"
    shift
    podman run --privileged --rm \
        -v /dev:/dev \
        -v /run/udev:/run/udev \
        -v "$cluster_dir:/data" \
        -w /data \
        quay.io/coreos/coreos-installer:release "${@}"
}

coreos-installer "$cluster_dir" iso ignition embed -fi iso.ign rhcos-live.x86_64.iso