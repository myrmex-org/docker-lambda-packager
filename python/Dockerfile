FROM amazonlinux:2

MAINTAINER Alexis Hénaut "alexis@henaut.net"

ARG PYTHON_VERSION

ENV DEFAULT_USER myrmex

# Install python and create a non root user
RUN yum install -y wget util-linux tar zip rsync make gcc-c++ zlib-devel bzip2-devel shadow-utils openssl-devel libffi-devel &&\
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz &&\
    tar xzf Python-${PYTHON_VERSION}.tgz &&\
    cd Python-${PYTHON_VERSION} &&\
    ./configure --enable-optimizations &&\
    make altinstall &&\
    cd .. &&\
    rm Python-${PYTHON_VERSION}.tgz &&\
    rm -rf Python-${PYTHON_VERSION} &&\
    useradd $DEFAULT_USER -m -d /workspace -s /bin/bash


# Set the build of a package as the default command
# Initialise RSYNC_OPTIONS to exclude the virtual environement folder
ENV RSYNC_OPTIONS --exclude venv --exclude .venv
COPY cmd.sh /cmd.sh
CMD ["/cmd.sh"]

# Use the non root user
USER $DEFAULT_USER

RUN cd /workspace &&\
    mkdir sources install package

# Sources for the package should be mounted or copied in /sources
WORKDIR /workspace/sources

