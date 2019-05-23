FROM amazonlinux:2

MAINTAINER Alexis N-o "alexis@henaut.net"

ENV DEFAULT_USER=myrmex
ENV NODE_VERSION_10 10.15.3

# Install gcc add utilities to manage users and permissions
RUN yum install -y gcc-c++ util-linux shadow-utils zlib-devel openssl-devel libffi-devel tar

# Install node v10
# Command "node" defaults to v10
RUN cd /opt &&\
    curl -O https://nodejs.org/dist/v${NODE_VERSION_10}/node-v${NODE_VERSION_10}-linux-x64.tar.gz &&\
    tar xvzf node-v${NODE_VERSION_10}-linux-x64.tar.gz &&\
    ln -s /opt/node-v${NODE_VERSION_10}-linux-x64/bin/node /usr/local/bin/node10 &&\
    ln -s /opt/node-v${NODE_VERSION_10}-linux-x64/bin/node /usr/local/bin/node &&\
    ln -s /opt/node-v${NODE_VERSION_10}-linux-x64/bin/npm /usr/local/bin/npm &&\
    /opt/node-v${NODE_VERSION_10}-linux-x64/bin/npm install -g npm@4

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
