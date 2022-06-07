ARG BASEIMAGE="docker.io/library/python:3.7-alpine"
ARG BASEIMAGE_USECASE="devtools"

FROM --platform=x86_64 ${BASEIMAGE} as devtools

LABEL io.while-true-do.site="https://while-true-do.io"
LABEL io.while-true-do.blog="https://blog.while-true-do.io"
LABEL io.while-true-do.code="https://github.com/whiletruedoio"
LABEL io.while-true-do.mail="hello@while-true-do.io"
#LABEL io.while-true-do.image.authors="dschier@while-true-do.io"

ARG USER="user"
ARG HOME="/home/${USER}"
ARG LIBGITVER="1.4.1"
ARG LIBGIT2="/lib64"

RUN set -xe \
  && adduser -D -h ${HOME} ${USER} \
  && apk add git \
  && apk add --no-cache --virtual .tmp-build-deps \
    openssl-dev cmake build-base libffi-dev libc-dev
#install libgit2 from source, no latest alpine pkgs provided
#libgit uses non-standard install path
#https://pkgs.org/search/?q=libgit
#https://www.pygit2.org/install.html#install-libgit2-from-source
RUN set -xe \
  && lgtmp="/libgit-temp" \
  && lgtar="${LIBGITVER}.tar.gz" \
  && lgurl="https://github.com/libgit2/libgit2/archive/refs/tags/v${lgtar}" \
  && mkdir -p $lgtmp && cd $lgtmp \
  && wget $lgurl -O $lgtar && tar xzf $lgtar && rm -f $lgtar \
  && cd "libgit2-${LIBGITVER}" \
  && cmake . -DCMAKE_INSTALL_PREFIX=$LIBGIT2 \
  && cmake --build . --target install \
  && cd / && rm -rf $lgtmp


FROM --platform=x86_64 ${BASEIMAGE_USECASE} as usecase

LABEL io.while-true-do.site="https://while-true-do.io"
LABEL io.while-true-do.blog="https://blog.while-true-do.io"
LABEL io.while-true-do.code="https://github.com/whiletruedoio"
LABEL io.while-true-do.mail="hello@while-true-do.io"
#LABEL io.while-true-do.image.authors="dschier@while-true-do.io"

ARG USER="user"
ARG HOME="/home/${USER}"
ARG FILES_IN="files/usr"
ARG FILES_USR="${HOME}/.local/bin"
ARG EP="${FILES_USR}/entrypoint.sh"
ARG LIBGIT2="/lib64"
ARG GITNAME=""
ARG GITDOMAIN=""
ARG DVC_STORTYPE=""
ARG DVC_ACCESS_KEY_ID=""
ARG DVC_ACCESS_KEY_SECRET=""

USER ${USER}
WORKDIR ${HOME}

ENV DVC_ACCESS_KEY_ID=$DVC_ACCESS_KEY_ID
ENV DVC_ACCESS_KEY_SECRET=$DVC_ACCESS_KEY_SECRET
ENV PATH="${FILES_USR}:${PATH}"

#pygit2
#fatal error: git2.h: No such file or directory
#https://www.pygit2.org/install.html#quick-install
#dvc remote storage
#https://dvc.org/doc/command-reference/remote
#dvc[type]: all, dvc-s3, dvc-azure, dvc-gdrive, dvc-gs, dvc-oss, dvc-ssh
RUN set -xe \
  && export LIBGIT2=${LIBGIT2} \
  #TODO append '$LDFLAGS' to append existing Flags ?
  #using triggers error 'cannot find $LDFLAGS: No such file or directory'
  && export LDFLAGS="-Wl,-rpath,'${LIBGIT2}${LIBGIT2}',--enable-new-dtags " \
  && python3 -m pip install --upgrade pip \
  && pip install --no-cache --user dvc[$DVC_STORTYPE] \
  && rm -rf ${HOME}/.cache

COPY --chown=${USER}:${USER} ${FILES_IN} ${FILES_USR}
RUN chmod +x ${EP}
RUN ${EP} ${GITNAME} ${GITDOMAIN}

CMD sh
#ENTRYPOINT dvc

USER root
RUN apk del .tmp-build-deps \
  && rm -rf /var/cache/apk/* /tmp/* \
    /usr/lib/python*/ensurepip
