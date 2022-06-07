#!/usr/bin/env sh
#https://dvc.org/doc/start
#https://dvc.org/doc/install/linux
#python install: https://github.com/iterative/dvc#pip-pypi
#https://medium.com/analytics-vidhya/docker-volumes-with-dvc-for-versioning-data-and-models-for-ml-projects-4885935db3ec
#https://github.com/iterative/dvc#comparison-to-related-technologies
#https://neptune.ai/blog/dvc-alternatives-for-experiment-tracking

set -xe

gitname=${1:-name}
gitdomain=${2:-dom.ain}

## init
mkdir dvc
cd dvc
git config --global user.email "${gitname}@${gitdomain}"
git config --global user.name $gitname
git init
dvc init
#https://dvc.org/doc/user-guide/analytics
dvc config --global core.analytics false
echo "DVC analytics: $(dvc config --global core.analytics)"
git commit -m "Initialize DVC"

## config
#dvc remote modify myremote access_key_id ${ACCESS_KEY_ID}
#dvc remote modify myremote secret_access_key ${ACCESS_KEY_SECRET}

## pull if inside dvc repo
#dvc pull

## exec app
#export APP_PORT=8088
#gunicorn --bind :$APP_PORT --workers 1 --threads 8 api:app

exit 0
