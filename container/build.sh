#!/usr/bin/env sh

tardevtools="devtools"
tarusecase="usecase"
tarall="all"
reg="localhost"
reguser="wtd-io"
dvc_stor_types=("all" "dvc-s3" "dvc-azure" \
  "dvc-gdrive" "dvc-gs" "dvc-oss" "dvc-ssh")

if [ "$1" == "$tardevtools" ] || [ "$1" == "$tarusecase" ]; then
  target=$1
elif [ "$1" == "$tarall" ]; then
  target="$tardevtools $tarusecase"
else
  target=$tarusecase
fi

for t in $target; do
  if [ $t == $tarusecase ]; then
    if [[ " ${dvc_stor_types[*]} " =~ " $3 " ]]; then
      dvc_stor_type=$3
    elif [ ! -z $3 ]; then
      echo "BUILD WARN: Omitting invalid DVC remote storage type '$3'."
      dvc_stor_type=""
    fi
    ba=' --build-arg '
    param=$ba'$ACCESS_KEY_ID='"'${ACCESS_KEY_ID:-default}'"
    param+=$ba'$ACCESS_KEY_SECRET='"'${ACCESS_KEY_SECRET:-default}'"
    param+=$ba'$DVC_STORTYPE='"'${dvc_stor_type}'"
    param+=$ba'$GITNAME='"'${4:-}'"
    param+=$ba'$GITDOMAIN='"'${5:-}'"
    if [ ! "$1" == "$tarall" ]; then
      param+=$ba'$BASEIMAGE_DVC='"'$reg/$reguser/$tardevtools:$tag'"
    fi
  else
    param=""
  fi
  param+=" --target $t"
  tagtmp="$reguser/$t:${2:-latest}"

  #TODO --squash or --squash-all ?

  echo "##########################################"
  echo "#    Building $tagtmp."
  echo "##########################################"
  echo $param
  podman build . -t $tagtmp $param
done
