[![Build Status](https://travis-ci.com/cjolowicz/docker-centos5.svg?branch=master)](https://travis-ci.com/cjolowicz/docker-centos5)

# docker-centos5

These Docker images provide Centos 5.11 with OpenSSL 1.1.0j installed
in /usr/local/ssl, and some tools built against it:

| Package | Images |
|---|---|
| OpenSSL 1.1.0j | [cjolowicz/openssl-centos5-x86_64](https://hub.docker.com/r/cjolowicz/openssl-centos5-x86_64)<br>[cjolowicz/openssl-centos5-i386](https://hub.docker.com/r/cjolowicz/openssl-centos5-i386) |
| Curl 7.64.0 | [cjolowicz/curl-centos5-x86_64](https://hub.docker.com/r/cjolowicz/curl-centos5-x86_64)<br>[cjolowicz/curl-centos5-i386](https://hub.docker.com/r/cjolowicz/curl-centos5-i386) |
| Git 2.21.0 | [cjolowicz/git-centos5-x86_64](https://hub.docker.com/r/cjolowicz/git-centos5-x86_64)<br>[cjolowicz/git-centos5-i386](https://hub.docker.com/r/cjolowicz/git-centos5-i386) |
| Python 3.6.8 | [cjolowicz/python-centos5-x86_64](https://hub.docker.com/r/cjolowicz/python-centos5-x86_64)<br>[cjolowicz/python-centos5-i386](https://hub.docker.com/r/cjolowicz/python-centos5-i386) |

The Docker images derive from the following base images:

- [astj/centos5-vault](https://hub.docker.com/r/astj/centos5-vault)
- [themattrix/centos5-vault-i386](https://hub.docker.com/r/themattrix/centos5-vault-i386)

## Background

On March 31, 2017, support of CentOS 5 has ended. The CentOS 5
official images have two issues that prevent them from talking to the
outside world:

- Yum repositories for CentOS 5 have been deleted.
- Tools such as curl and git lack support for TLS 1.2.

These Docker images rewrite yum repository urls in /etc/yum.repos.d to
vault.centos.org. The images are bootstrapped using the curl from
[tuxad.com](http://www.tuxad.com/blog/archives/2015/04/26/tuxad_yum_package_repository_for_rhel__centos_5_x86_64/index.html),
allowing us to download source tarballs from sites enforcing the use
of TLS 1.2.  We provide our own curl image, because while the curl
from tuxad.com does offer TLS 1.2 support, it still has some issues
with certificate validation, requiring the use of --insecure.

## Usage

Invoke `make` to build the images locally. This requires the
[m4](https://www.gnu.org/software/m4/) preprocessor.
