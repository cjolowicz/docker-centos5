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

FROM astj/centos5-vault

# We will be building packages from source.
WORKDIR /usr/local/src

# Download sources. The tuxad repository is needed to install curl
# with TLS 1.2 support. Most sites won't settle for any less.  After
# download, remove the repository.
#
# Configure yum's multilib_policy to prevent installation failures due
# to collision with i386 packages.
# https://serverfault.com/questions/77122/rhel5-forbid-installation-of-i386-packages-on-64-bit-systems
RUN echo "multilib_policy=best" >> /etc/yum.conf && \
    rpm -i http://www.tuxad.de/repo/5/tuxad.rpm && \
    yum update -y && yum install -y curl && \
    curl --insecure http://www.cpan.org/src/5.0/perl-5.28.1.tar.gz -LO && \
    curl --insecure https://www.openssl.org/source/openssl-1.1.0j.tar.gz -LO && \
    curl --insecure https://curl.haxx.se/download/curl-7.64.0.tar.gz -LO && \
    yum remove -y curl openssl1 && \
    rpm --erase tuxad-release-5-7

# Install pre-requisites.
RUN yum install -y \
    file \
    gcc \
    make \
    openldap-devel \
    zlib-devel \
    && yum clean all

# Install Perl from source.
# OpenSSL requires >= 5.10.0, repositories have 5.8.8.
RUN tar -xf perl-5.28.1.tar.gz && \
    cd perl-5.28.1 && \
    ./Configure -des && \
    make && \
    make install && \
    cd .. && \
    rm -rf perl-5.28.1 perl-5.28.1.tar.gz

# Install OpenSSL from source.
RUN tar -xf openssl-1.1.0j.tar.gz && \
    cd openssl-1.1.0j && \
    ./config \
        --prefix=/usr/local/ssl \
        --openssldir=/usr/local/ssl \
        shared zlib no-async enable-egd \
        -Wl,-rpath,/usr/local/ssl/lib && \
    make && \
    make install && \
    cd .. && \
    rm -rf openssl-1.1.0j openssl-1.1.0j.tar.gz

ENV PKG_CONFIG_PATH /usr/local/ssl/lib/pkgconfig

RUN tar -xf curl-7.64.0.tar.gz && \
    cd curl-7.64.0 && \
    LDFLAGS=-Wl,-R/usr/local/ssl/lib ./configure --with-ssl=/usr/local/ssl && \
    make && \
    make install && \
    cd .. && \
    rm -rf curl-7.64.0 curl-7.64.0.tar.gz
