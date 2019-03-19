m4_define(YUM, m4_ifelse(ARCH, `x86_64', `yum', ARCH, `i386', `linux32 yum'))m4_dnl
#
# Docker Image for OpenSSL 1.1.0j on Centos 5
#
#
# Use 1.1.0j because compiling 1.1.1b fails with an assembler error.
#
# Invoke curl with `--insecure` because of this:
#
#   curl: (60) SSL certificate problem, verify that the CA cert is OK. Details:
#   error:14090086:SSL routines:SSL3_GET_SERVER_CERTIFICATE:certificate verify failed
#

FROM m4_ifelse(
    ARCH, `x86_64',
    `astj/centos5-vault',
    ARCH, `i386',
    `themattrix/centos5-vault-i386')

ENV PERL_VERSION 5.28.1
ENV OPENSSL_VERSION 1.1.0j
ENV OPENSSL_DIR /usr/local/ssl

# Configure yum's multilib_policy to prevent installation failures.
# https://serverfault.com/questions/77122/rhel5-forbid-installation-of-i386-packages-on-64-bit-systems
RUN echo "multilib_policy=best" >> /etc/yum.conf

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
    curl --insecure http://www.cpan.org/src/5.0/perl-$PERL_VERSION.tar.gz -LO; \
    curl --insecure https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz -LO; \
    YUM remove -y curl openssl1; \
    rpm --erase m4_ifelse(ARCH, `x86_64', `tuxad-release-5-7', ARCH, `i386', `tuxad-release'); \
    YUM clean all

# Install pre-requisites.
RUN set -ex; \
    YUM update -y; \
    YUM install -y \
        gcc \
        make \
        openldap-devel \
        zlib-devel \
    ; \
    YUM clean all

# Install Perl from source.
# OpenSSL requires >= 5.10.0, repositories have 5.8.8.
RUN set -ex; \
    cd /usr/local/src; \
    tar -xf perl-$PERL_VERSION.tar.gz; \
    rm -f perl-$PERL_VERSION.tar.gz; \
    cd perl-$PERL_VERSION; \
    ./Configure -des; \
    make -j $(grep -c processor /proc/cpuinfo); \
    make install; \
    cd ..; \
    rm -rf perl-$PERL_VERSION

# Install OpenSSL from source.
RUN set -ex; \
    cd /usr/local/src; \
    tar -xf openssl-$OPENSSL_VERSION.tar.gz; \
    rm -f openssl-$OPENSSL_VERSION.tar.gz; \
    cd openssl-$OPENSSL_VERSION; \
    m4_ifelse(
        ARCH, `x86_64',
        `./config',
        ARCH, `i386',
        `./Configure -m32 linux-generic32') \
        --prefix=$OPENSSL_DIR \
        --openssldir=$OPENSSL_DIR \
        shared zlib no-async enable-egd \
        -Wl,-rpath,$OPENSSL_DIR/lib; \
    make -j $(grep -c processor /proc/cpuinfo); \
    make install_sw; \
    cd ..; \
    rm -rf openssl-$OPENSSL_VERSION; \
    echo $OPENSSL_DIR/lib > /etc/ld.so.conf.d/openssl-$OPENSSL_VERSION.conf; \
    ldconfig -v; \
    $OPENSSL_DIR/bin/openssl version -a

ENV PATH $OPENSSL_DIR/bin:$PATH
ENV PKG_CONFIG_PATH $OPENSSL_DIR/lib/pkgconfig
