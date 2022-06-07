#!/bin/bash

image=localhost/wtd-dvc
regport=5000
regtar=/var/lib/registry
reghost=localhost

sudo mkdir -p $regtar
sudo podman run --privileged -d --name registry \
  -p $regport:$regport -v $regtar:$regtar \
  --restart=always registry:2

imagetag=${image/${reghost}/${reghost}:${regport}}
podman tag $image $imagetag
podman push $image

#let's encrypt

export DOMAIN="registry.wtd.io"
export EMAIL="registry@wtd.io"
sudo certbot -n --agree-tos --standalone certonly -d $DOMAIN -m $EMAIL

