m4_define(YUM, m4_ifelse(ARCH, `x86_64', `yum', ARCH, `i386', `linux32 yum'))m4_dnl
#
# Docker Image for Curl 7.64.0 on Centos 5
#

FROM REPO/openssl-centos5-ARCH:1.1.0j

ENV CURL_VERSION 7.64.0

# Download sources, using tuxad.de's curl for TLS 1.2 support.
RUN set -ex; \
    cd /usr/local/src; \
    rpm -i m4_ifelse(
        ARCH, `x86_64',
        `http://www.tuxad.de/repo/5/tuxad.rpm',
        ARCH, `i386',
        `http://www.tuxad.com/rpms/tuxad-release-5-1.noarch.rpm',
    ); \
    YUM update -y; \
    YUM install -y curl; \
    curl --insecure https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz -LO; \
    YUM remove -y curl openssl1; \
    rpm --erase m4_ifelse(ARCH, `x86_64', `tuxad-release-5-7', ARCH, `i386', `tuxad-release'); \
    YUM clean all

# Install pre-requisites.
RUN set -ex; \
    YUM update -y; \
    YUM install -y \
        file \
    ; \
    YUM clean all

RUN set -ex; \
    cd /usr/local/src; \
    tar -xf curl-$CURL_VERSION.tar.gz; \
    rm -f curl-$CURL_VERSION.tar.gz; \
    cd curl-$CURL_VERSION; \
    LDFLAGS=-Wl,-R$OPENSSL_DIR/lib \
    ./configure \
        --with-ssl=$OPENSSL_DIR \
        m4_ifelse(ARCH, `i386', `--host=i686-pc-linux-gnu CFLAGS=-m32'); \
    make -j $(grep -c processor /proc/cpuinfo); \
    make install; \
    cd ..; \
    rm -rf curl-$CURL_VERSION; \
    /usr/local/bin/curl --version

ENV PATH /usr/local/bin:$PATH
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
