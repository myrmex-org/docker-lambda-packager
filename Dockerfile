FROM amazonlinux:1

MAINTAINER Alexis N-o "alexis@henaut.net"

ENV DEFAULT_USER=myrmex
ENV NODE_VERSION_4 4.3.2
ENV NODE_VERSION_6 6.10.2
ENV NODE_VERSION_8 8.10.0

# Install gcc add utilities to manage users and permissions
RUN yum install -y gcc-c++ util-linux shadow-utils zlib-devel openssl-devel libffi-devel

# Install node v4 node v6 and node v8 as commands "node4" "node6" and "node8"
# Command "node" defaults to v8
# Update npm to version 4
RUN cd /opt &&\
    curl -O https://nodejs.org/dist/v${NODE_VERSION_4}/node-v${NODE_VERSION_4}-linux-x64.tar.gz &&\
    tar xvzf node-v${NODE_VERSION_4}-linux-x64.tar.gz &&\
    ln -s /opt/node-v${NODE_VERSION_4}-linux-x64/bin/node /usr/local/bin/node4 &&\
    ln -s /opt/node-v${NODE_VERSION_4}-linux-x64/bin/node /usr/local/bin/node &&\
    ln -s /opt/node-v${NODE_VERSION_4}-linux-x64/bin/npm /usr/local/bin/npm &&\
    /opt/node-v${NODE_VERSION_4}-linux-x64/bin/npm install -g npm@4 &&\
    rm /usr/local/bin/node /usr/local/bin/npm &&\
    curl -O https://nodejs.org/dist/v${NODE_VERSION_6}/node-v${NODE_VERSION_6}-linux-x64.tar.gz &&\
    tar xvzf node-v${NODE_VERSION_6}-linux-x64.tar.gz &&\
    ln -s /opt/node-v${NODE_VERSION_6}-linux-x64/bin/node /usr/local/bin/node6 &&\
    ln -s /opt/node-v${NODE_VERSION_6}-linux-x64/bin/node /usr/local/bin/node &&\
    ln -s /opt/node-v${NODE_VERSION_6}-linux-x64/bin/npm /usr/local/bin/npm &&\
    /opt/node-v${NODE_VERSION_6}-linux-x64/bin/npm install -g npm@4 &&\
    rm /usr/local/bin/node /usr/local/bin/npm &&\
    curl -O https://nodejs.org/dist/v${NODE_VERSION_8}/node-v${NODE_VERSION_8}-linux-x64.tar.gz &&\
    tar xvzf node-v${NODE_VERSION_8}-linux-x64.tar.gz &&\
    ln -s /opt/node-v${NODE_VERSION_8}-linux-x64/bin/node /usr/local/bin/node8 &&\
    ln -s /opt/node-v${NODE_VERSION_8}-linux-x64/bin/node /usr/local/bin/node &&\
    ln -s /opt/node-v${NODE_VERSION_8}-linux-x64/bin/npm /usr/local/bin/npm &&\
    /opt/node-v${NODE_VERSION_8}-linux-x64/bin/npm install -g npm@4

# Install python 3.6 and pip, python 2.7 is already available
RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
    python get-pip.py &&\
    curl -O https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz &&\
    tar zxvf Python-3.6.1.tgz &&\
    cd Python-3.6.1 &&\
    ./configure --prefix=/opt/python3 &&\
    make &&\
    make install &&\
    ln -s /opt/python3/bin/python3 /usr/bin/python3 &&\
    ln -s /opt/python3/bin/pip3 /usr/bin/pip3


# Add a script to modify the UID / GID for the default user if needed
COPY /usr/local/bin/change-uid /usr/local/bin/change-uid
RUN chmod +x /usr/local/bin/change-uid

# Add a non root user
RUN useradd $DEFAULT_USER -m -d /home/$DEFAULT_USER/ -s /bin/bash

# Create working directory
RUN mkdir /data && chown $DEFAULT_USER:$DEFAULT_USER /data
WORKDIR /data

# Add entrypoint
COPY /entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Add default command
COPY /cmd.sh /cmd.sh
RUN chmod +x /cmd.sh
CMD ["/cmd.sh"]
