FROM amazonlinux:2

MAINTAINER Alexis N-o "alexis@henaut.net"

ENV DEFAULT_USER=myrmex
ENV NODE_VERSION_10 10.16.3

# Install gcc add utilities to manage users and permissions
RUN yum install -y gcc-c++ util-linux shadow-utils zlib-devel openssl-devel libffi-devel tar

# Add a script to install node versions
COPY /install-node.sh /install-node.sh

# Install node v10
# Command "node" defaults to v10
RUN /install-node.sh ${NODE_VERSION_10}

# Add a script to modify the UID / GID for the default user if needed
COPY /usr/local/bin/change-uid /usr/local/bin/change-uid
RUN chmod +x /usr/local/bin/change-uid

# Add a non root user
RUN useradd $DEFAULT_USER -m -d /home/$DEFAULT_USER/ -s /bin/bash

# Create working directory
RUN mkdir /data && chown $DEFAULT_USER:$DEFAULT_USER /data
WORKDIR /data

# Add entrypoint
COPY /al2.entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Add default command
COPY /cmd.sh /cmd.sh
RUN chmod +x /cmd.sh
CMD ["/cmd.sh"]
