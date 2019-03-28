# Docker image to create Amazon Lambda packages

## Why?

Some node and python modules require a build system because they contain c++ binding. Once deployed, the compiled
module may not be compatible with the Amazon Lambda execution environment.

A common solution to this problem is to build the package on an EC2 instance using an Amazon Linux AMI and then to
deploy it in Amazon Lambda. Building serverless applications, it is ironic to be obliged to use an EC2 server to deploy code.

This docker image is based on the [Amazon Linux 1](https://hub.docker.com/_/amazonlinux/) image and contains `gcc`,
`python 2.7`, `python 3.6`, `python 3.7`, `pip`, `node 6.10`, `node 8.10` to create packages for Amazon Lambda.

Using the docker image `myrmex/lambda-packager`, you can avoid errors like these during execution in Amazon Lambda:

```
/var/lang/lib/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by /var/task/node_modules/bcrypt/lib/binding/bcrypt_lib.node)
```

```
Module version mismatch. Expected 46, got 48.
```

## Usage

You can use a docker volume to mount the code of the Lambda in a container. The directory where `npm install` or
`pip install` is executed inside the container is `/data`. By default, the installation will be performed for node
6.10.

```bash
docker run -v `pwd`:/data myrmex/lambda-packager
```

The image does not create the zip archive for your. It only installs the dependencies in an environment compatible with
Lambda. You will still have to zip the result and deploy it in Amazon Lambda.

For a node package, take care that `node_module` does not already exist before running the command.

### Managing permissions

The user account that performs `npm install` or `pip install` inside the container may have a `uid/gid` that differs from the
`uid/gid` of the host machine and will not be able to perform the installation. The image `myrmex/lambda-packager`
accepts two environment variables that allows to modify the `uid/gid` of the container's user: `HOST_UID` and
`HOST_GID`. If `HOST_GID` is omitted, its value will be set to the value of `HOST_UID`.

```bash
docker run -e HOST_UID=`id -u` -e HOST_GID=`id -g` -v `pwd`:/data myrmex/lambda-packager
```

### Selecting the runtime

The `RUNTIME` environment variable allows to choose the runtime.


#### Node 8.10

Node 8.10 is the default runtime and does not require any special configuration.

#### Node 6.10

```bash
docker run -e RUNTIME=node6 -v `pwd`:/data myrmex/lambda-packager
```

#### Python 3.7

Python 3.7 is the default Python 3 runtime and accepts the values `python3` or `python3.7`

```bash
docker run -e RUNTIME=python3.7 -v `pwd`:/data myrmex/lambda-packager
```

#### Python 3.6

```bash
docker run -e RUNTIME=python3.6 -v `pwd`:/data myrmex/lambda-packager
```

#### Python 2.7

Accepts the values `python` or `python2`.

```bash
docker run -e RUNTIME=python -v `pwd`:/data myrmex/lambda-packager
```

### Default command

To be able to change the user `uid/gid`, the container is executed with the root user. But to execute `npm install`, we
need to use a non root user because it is a good practice and it avoids some [bad surprises with
`node-gyp`](https://github.com/nodejs/node-gyp/issues/454).

So, the default command is `su myrmex -c "npm install --production"`, `myrmex` beeing the name of the non root user.

For python, the command is `su myrmex -c "pip install --requirement requirements.txt --upgrade --target ."`
