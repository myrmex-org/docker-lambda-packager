FROM amazonlinux:1

MAINTAINER Alexis N-o "alexis@henaut.net"

ENV DEFAULT_USER=myrmex
ENV NODE_VERSION_6 6.10.3
ENV NODE_VERSION_8 8.10.0
ENV PYTHON_VERSION_3_6 3.6.8
ENV PYTHON_VERSION_3_7 3.7.3

# Install gcc add utilities to manage users and permissions
RUN yum install -y gcc-c++ util-linux shadow-utils zlib-devel openssl-devel libffi-devel

# Add scripts to install node and python versions
COPY /install-node.sh /install-node.sh
COPY /install-python.sh /install-python.sh

# Install node v6 and node v8 as commands "node6" and "node8"
# Command "node" defaults to v8
RUN /install-node.sh ${NODE_VERSION_6} &&\
    /install-node.sh ${NODE_VERSION_8}

# Install python 3.6 and python 3.7 including pip, python 2.7 is already available
# Command "python3" defaults to 3.7
RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
    python get-pip.py &&\
    /install-python.sh ${PYTHON_VERSION_3_6} &&\
    /install-python.sh ${PYTHON_VERSION_3_7}

# Add a script to modify the UID / GID for the default user if needed
COPY /usr/local/bin/change-uid /usr/local/bin/change-uid
RUN chmod +x /usr/local/bin/change-uid

# Add a non root user
RUN useradd $DEFAULT_USER -m -d /home/$DEFAULT_USER/ -s /bin/bash

# Create working directory
RUN mkdir /data && chown $DEFAULT_USER:$DEFAULT_USER /data
WORKDIR /data

# Add entrypoint
COPY /al1.entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Add default command
COPY /cmd.sh /cmd.sh
RUN chmod +x /cmd.sh
CMD ["/cmd.sh"]
