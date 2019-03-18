#
# Docker Image for Python 3.6.8 on Centos 5
#

FROM REPO/curl-centos5-ARCH:7.64.0

# Install pre-requisites.
RUN set -ex; \
    yum update -y; \
    yum install -y \
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
    ; \
    yum clean all

ENV PYTHON_VERSION 3.6.8

# https://stackoverflow.com/questions/5937337/building-python-with-ssl-support-in-non-standard-location
COPY use-local-openssl.patch /usr/local/src

RUN set -ex;
    cd /usr/local/src; \
    curl https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz -LO; \
    tar -xf Python-$PYTHON_VERSION.tgz; \
    rm -f Python-$PYTHON_VERSION.tgz; \
    cd Python-$PYTHON_VERSION; \
    patch -p1 < ../use-local-openssl.patch; \
    ./configure \
        --enable-loadable-sqlite-extensions \
        --enable-shared \
        --with-system-expat \
        --with-system-ffi \
        --without-ensurepip \
        CPPFLAGS="$(pkg-config --cflags openssl) -Wl,-R$OPENSSL_DIR/lib" \
        LDFLAGS="$(pkg-config --libs openssl) -Wl,-R$OPENSSL_DIR/lib"; \
    make -j $(nproc); \
    make install; \
    ldconfig; \
    find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' + \
    ; \
    cd ..; \
    rm -rf Python-$PYTHON_VERSION; \
    python3 --version

# make some useful symlinks that are expected to exist
RUN set -ex; \
    cd /usr/local/bin; \
    ln -s idle3 idle; \
    ln -s pydoc3 pydoc; \
    ln -s python3 python; \
    ln -s python3-config python-config

ENV PYTHON_PIP_VERSION 19.0.3

RUN set -ex; \
    cd /usr/local/src; \
    curl -LO 'https://bootstrap.pypa.io/get-pip.py'; \
    python get-pip.py \
        --disable-pip-version-check \
        --no-cache-dir \
        "pip==$PYTHON_PIP_VERSION" \
    ; \
    pip --version; \
    find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' + \
    ; \
    rm -f get-pip.py

ENTRYPOINT ["python3"]
