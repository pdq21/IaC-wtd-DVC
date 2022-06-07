#!/usr/bin/env sh

tagusecase="dvc"
dvc_stor_types=("all" "dvc-s3" "dvc-azure" \
  "dvc-gdrive" "dvc-gs" "dvc-oss" "dvc-ssh")
reg="localhost"
reguser="wtd-io"

tardevtools="devtools"
tarusecase="usecase"
tarall="all"

if [ "$1" == "$tardevtools" ] || [ "$1" == "$tarusecase" ]; then
  target=$1
elif [ "$1" == "$tarall" ]; then
  target="$tardevtools $tarusecase"
else
  target=$tarusecase
fi

for t in $target; do

  #TODO --squash or --squash-all ?
  param=" --target $t"

  if [ $t == $tarusecase ]; then
    tagtmp=$tagusecase
    ba=' --build-arg '
    param="${ba}DVC_ACCESS_KEY_ID=${DVC_ACCESS_KEY_ID}"
    param+="${ba}DVC_ACCESS_KEY_SECRET=${DVC_ACCESS_KEY_SECRET}"
    param+="${ba}GITNAME=${4:-}"
    param+="${ba}GITDOMAIN=${5:-}"
    if [ "$1" == "$tarusecase" ]; then
      #ARG FROM syntax needs $-denotion
      param+=$ba'$BASEIMAGE_USECASE='${reg}/${reguser}/${tardevtools}:${2:-latest}
    fi
    if [[ " ${dvc_stor_types[*]} " =~ " $3 " ]]; then
      param+="${ba}DVC_STORTYPE=${3}"
    elif [ ! -z $3 ]; then
      echo "BUILD WARN: Omitting invalid DVC remote storage type '$3'."
    fi
  else
    tagtmp=$t
  fi
  
  tagtmp="${reguser}/${tagtmp}:${2:-latest}"

  echo "##########################################"
  echo "#    Building $tagtmp"
  echo "##########################################"
  echo $param
  podman build . -t $tagtmp $param

done
