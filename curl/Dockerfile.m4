#
# Docker Image for Curl 7.64.0 on Centos 5
#

FROM cjolowicz/openssl-centos5:1.1.0j

ENV CURL_VERSION 7.64.0

# Download sources, using tuxad.de's curl for TLS 1.2 support.
RUN rpm -i http://www.tuxad.de/repo/5/tuxad.rpm && \
    yum update -y && yum install -y curl && \
    curl --insecure https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz -LO && \
    yum remove -y curl openssl1 && \
    rpm --erase tuxad-release-5-7

# Install pre-requisites.
RUN yum install -y \
    file \
    && yum clean all

RUN tar -xf curl-$CURL_VERSION.tar.gz && \
    cd curl-$CURL_VERSION && \
    LDFLAGS=-Wl,-R/usr/local/ssl/lib ./configure --with-ssl=/usr/local/ssl && \
    make && \
    make install && \
    cd .. && \
    rm -rf curl-$CURL_VERSION curl-$CURL_VERSION.tar.gz

CMD ["curl"]
