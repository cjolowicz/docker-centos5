#
# Docker Image for Git 2.21.0 on Centos 5
#

FROM cjolowicz/curl:7.64.0-centos5

RUN yum update -y && yum install -y \
    expat-devel \
    gettext-devel \
    zlib-devel \
    && yum clean all

RUN curl https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.21.0.tar.gz -LO && \
    tar -xf git-2.21.0.tar.gz && \
    cd git-2.21.0 && \
    ./configure --with-openssl=/usr/local/ssl --with-curl=/usr/local && \
    make && \
    make install && \
    cd .. && \
    rm -rf git-2.21.0 git-2.21.0.tar.gz
