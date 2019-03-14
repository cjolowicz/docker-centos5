#
# Docker Image for Python 3.6.8 on Centos 5
#

FROM cjolowicz/curl-centos5:7.64.0

# Install pre-requisites.
RUN yum update -y && yum install -y \
    bzip2 \
    bzip2-devel \
    findutils \
    patch \
    readline-devel \
    sqlite \
    sqlite-devel \
    xz \
    xz-devel \
    zlib-devel \
    && yum clean all

# https://stackoverflow.com/questions/5937337/building-python-with-ssl-support-in-non-standard-location
COPY use-local-openssl.patch .

RUN curl https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz -LO && \
    tar -xf Python-3.6.8.tgz && \
    cd /usr/local/src/Python-3.6.8 && \
    patch -p1 < ../use-local-openssl.patch && \
    ./configure --with-ensurepip=install \
    CPPFLAGS="$(pkg-config --cflags openssl) -Wl,-R/usr/local/ssl/lib" \
    LDFLAGS="$(pkg-config --libs openssl) -Wl,-R/usr/local/ssl/lib" && \
    make && \
    make install && \
    cd .. && \
    rm -rf Python-3.6.8 Python-3.6.8.tgz
