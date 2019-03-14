[![Build Status](https://travis-ci.com/cjolowicz/docker-centos5.svg?branch=master)](https://travis-ci.com/cjolowicz/docker-centos5)

# docker-centos5

These Docker images provide Centos 5.11 with OpenSSL 1.1.0j installed
in /usr/local/ssl, and some tools built against it:

- Curl 7.64.0
- Git 2.21.0
- Python 3.6.8

On March 31, 2017, support of CentOS 5 has ended. The CentOS 5
official image have two issues that prevent them from talking to the
outside world:

- Yum repositories for CentOS 5 have been deleted.
- Tools such as curl and git lack support for TLS 1.2.

These Docker images derive from
https://github.com/astj/docker-centos5-vault, which rewrites yum
repository urls in /etc/yum.repos.d to vault.centos.org. The images
are bootstrapped using the curl from
[tuxad.com](http://www.tuxad.com/blog/archives/2015/04/26/tuxad_yum_package_repository_for_rhel__centos_5_x86_64/index.html),
allowing us to download source tarballs from sites enforcing the use
of TLS 1.2.  We provide our own curl image, because while the curl
from tuxad.com does offer TLS 1.2 support, it still has some issues
with certificate validation, requiring the use of --insecure.
