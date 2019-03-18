#
# Docker Image for Git 2.21.0 on Centos 5
#

FROM cjolowicz/curl-centos5-ARCH:7.64.0

RUN set -ex; \
    yum update -y; \
    yum install -y \
        expat-devel \
        gettext-devel \
    ; \
    yum clean all

ENV GIT_VERSION 2.21.0

RUN set -ex; \
    curl https://mirrors.edge.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz -LO; \
    tar -xf git-$GIT_VERSION.tar.gz; \
    rm -f git-$GIT_VERSION.tar.gz; \
    cd git-$GIT_VERSION; \
    ./configure \
        --with-openssl=$OPENSSL_DIR \
        --with-curl=/usr/local \
    ; \
    make -j $(nproc); \
    make install; \
    cd ..; \
    rm -rf git-$GIT_VERSION; \
    git --version

ENTRYPOINT ["git"]
