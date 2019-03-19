m4_define(YUM, m4_ifelse(ARCH, `x86_64', `yum', ARCH, `i386', `linux32 yum'))m4_dnl
#
# Docker Image for Git 2.21.0 on Centos 5
#

FROM REPO/curl-centos5-ARCH:7.64.0

RUN set -ex; \
    YUM update -y; \
    YUM install -y \
        expat-devel \
        gettext-devel \
    ; \
    YUM clean all

ENV GIT_VERSION 2.21.0

RUN set -ex; \
    cd /usr/local/src; \
    curl https://mirrors.edge.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz -LO; \
    tar -xf git-$GIT_VERSION.tar.gz; \
    rm -f git-$GIT_VERSION.tar.gz; \
    cd git-$GIT_VERSION; \
    ./configure \
        --with-openssl=$OPENSSL_DIR \
        --with-curl=/usr/local \
    ; \
    make -j $(grep -c processor /proc/cpuinfo); \
    make install; \
    cd ..; \
    rm -rf git-$GIT_VERSION; \
    git --version

ENTRYPOINT ["git"]
