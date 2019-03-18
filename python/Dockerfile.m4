#
# Docker Image for Python 3.6.8 on Centos 5
#

FROM cjolowicz/curl-centos5-ARCH:7.64.0

ENV PYTHON_VERSION 3.6.8

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

RUN curl https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz -LO && \
    tar -xf Python-$PYTHON_VERSION.tgz && \
    cd /usr/local/src/Python-$PYTHON_VERSION && \
    patch -p1 < ../use-local-openssl.patch && \
    ./configure --with-ensurepip=install \
    CPPFLAGS="$(pkg-config --cflags openssl) -Wl,-R/usr/local/ssl/lib" \
    LDFLAGS="$(pkg-config --libs openssl) -Wl,-R/usr/local/ssl/lib" && \
    make && \
    make install && \
    cd .. && \
    rm -rf Python-$PYTHON_VERSION Python-$PYTHON_VERSION.tgz

CMD ["python3"]
