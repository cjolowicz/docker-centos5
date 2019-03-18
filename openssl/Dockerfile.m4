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

ENV PERL_VERSION 5.28.1
ENV OPENSSL_VERSION 1.1.0j

# We will be building packages from source.
WORKDIR /usr/local/src

# Ensure our tools are preferred over distribution tools.
ENV PATH /usr/local/bin:$PATH

# Configure yum's multilib_policy to prevent installation failures.
# https://serverfault.com/questions/77122/rhel5-forbid-installation-of-i386-packages-on-64-bit-systems
RUN echo "multilib_policy=best" >> /etc/yum.conf

# Download sources, using tuxad.de's curl for TLS 1.2 support.
RUN rpm -i http://www.tuxad.de/repo/5/tuxad.rpm && \
    yum update -y && yum install -y curl && \
    curl --insecure http://www.cpan.org/src/5.0/perl-$PERL_VERSION.tar.gz -LO && \
    curl --insecure https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz -LO && \
    yum remove -y curl openssl1 && \
    rpm --erase tuxad-release-5-7

# Install pre-requisites.
RUN yum install -y \
    gcc \
    make \
    openldap-devel \
    zlib-devel \
    && yum clean all

# Install Perl from source.
# OpenSSL requires >= 5.10.0, repositories have 5.8.8.
RUN tar -xf perl-$PERL_VERSION.tar.gz && \
    cd perl-$PERL_VERSION && \
    ./Configure -des && \
    make && \
    make install && \
    cd .. && \
    rm -rf perl-$PERL_VERSION perl-$PERL_VERSION.tar.gz

# Install OpenSSL from source.
RUN tar -xf openssl-$OPENSSL_VERSION.tar.gz && \
    cd openssl-$OPENSSL_VERSION && \
    ./config \
        --prefix=/usr/local/ssl \
        --openssldir=/usr/local/ssl \
        shared zlib no-async enable-egd \
        -Wl,-rpath,/usr/local/ssl/lib && \
    make && \
    make install && \
    cd .. && \
    rm -rf openssl-$OPENSSL_VERSION openssl-$OPENSSL_VERSION.tar.gz

ENV PKG_CONFIG_PATH /usr/local/ssl/lib/pkgconfig

CMD ["openssl"]
