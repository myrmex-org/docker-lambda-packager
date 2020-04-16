FROM amazonlinux:2

MAINTAINER Alexis Hénaut "alexis@henaut.net"

ARG NODE_VERSION

ENV DEFAULT_USER myrmex

# Install NodeJS and create a non root user
RUN yum install -y wget gzip tar zip rsync shadow-utils gcc-c++ &&\
    cd /opt &&\
    wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz &&\
    tar xvzf node-v${NODE_VERSION}-linux-x64.tar.gz &&\
    rm node-v${NODE_VERSION}-linux-x64.tar.gz &&\
    ln -fs /opt/node-v${NODE_VERSION}-linux-x64/bin/node /usr/local/bin/node &&\
    ln -fs /opt/node-v${NODE_VERSION}-linux-x64/bin/npm /usr/local/bin/npm &&\
    ln -fs /opt/node-v${NODE_VERSION}-linux-x64/bin/npx /usr/local/bin/npx &&\
    useradd $DEFAULT_USER -m -d /workspace -s /bin/bash

# Set the build of a package as the default command
# Initialise RSYNC_OPTIONS to exclude the node_modules folder
ENV RSYNC_OPTIONS --exclude node_modules
COPY cmd.sh /cmd.sh
CMD ["/cmd.sh"]

# Use the non root user
USER $DEFAULT_USER

RUN cd /workspace &&\
    mkdir sources install package

# Sources for the package should be mounted or copied in /sources
WORKDIR /workspace/sources
