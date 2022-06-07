#!/bin/bash

usecase="dvc"
reghost="localhost"
regport=5000
regtar="/var/lib/registry"


image="${reghost}/wtd-${usecase}"

sudo mkdir -p $regtar
sudo podman run --privileged -d --name registry \
  -p $regport:$regport -v $regtar:$regtar \
  --restart=always registry:2

podman tag $image ${image/${reghost}/${reghost}:${regport}}
podman push $image

#let's encrypt

export DOMAIN="registry.wtd.io"
export EMAIL="registry@wtd.io"
sudo certbot -n --agree-tos --standalone certonly -d $DOMAIN -m $EMAIL


