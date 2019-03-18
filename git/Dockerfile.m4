#
# Docker Image for Git 2.21.0 on Centos 5
#

FROM cjolowicz/curl-centos5:7.64.0

ENV GIT_VERSION 2.21.0

RUN yum update -y && yum install -y \
    expat-devel \
    gettext-devel \
    zlib-devel \
    && yum clean all

RUN curl https://mirrors.edge.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz -LO && \
    tar -xf git-$GIT_VERSION.tar.gz && \
    cd git-$GIT_VERSION && \
    ./configure --with-openssl=/usr/local/ssl --with-curl=/usr/local && \
    make && \
    make install && \
    cd .. && \
    rm -rf git-$GIT_VERSION git-$GIT_VERSION.tar.gz

CMD ["git"]
