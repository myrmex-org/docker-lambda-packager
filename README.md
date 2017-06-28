# Docker image to create AWS Lambda packages

## Why?

Some node modules require a build system because they contain c++ binding. Once deployed, the compiled module may not be
complatible with the Lambda execution environment.

A common solution to this problem is to create the package to deploy in Amazon Lambda on an EC2 instance using an Amazon
Linux AMI. Building serverless applications, it is ironic to need a server to deploy on Lambda.

This docker image is based on the [Amazon Linux](https://hub.docker.com/_/amazonlinux/) image and contains gcc, node 4.3.2, node 6.10.2 and npm 5 to create packages for Lambda.

## Usage

From the directory that contain the code of the Lambda, you can use a docker volume to mount it in the container. The
directory wher `npm install` is executed inside the container is `/data`. By default, the installation will be done for node
6.10.2.

```bash
docker run `pwd`:/data myrmex/lambda-packager
```

Take care that `node_module` does not already exist before running the command.

### Managing permissions

The user that performs `npm install` inside the container may have a uid/gid that differs from the uid/gid of the host machine
and npm may not be able to perform the installation. The image `myrmex/lambda-packager` accepts too environment variables
that allows to modify the uid/gid for the container's user: `HOST_UID` and `HOST_GID`. If `HOST_GID` is omitted, its value
will be set to the value of `HOST_UID`.

```bash
docker run -e HOST_UID=`id -u` -e HOST_GID=`id -g`-e RUNTIME=node4 -v `pwd`:/data myrmex/lambda-packager
```

### Node 4

The `RUNTIME` environment variable allows to perform the installation for node 4.3.2

```bash
docker run -e HOST_UID=`id -u` -e HOST_GID=`id -g`-e RUNTIME=node4 -v `pwd`:/data myrmex/lambda-packager
```

### Default command

To be able to change the user uid/gid, the container is executed with the root user. But to execute `npm install`, we need to
use a non root user because it is a good practice and it avoids some [bad surprises with
`node-gyp`](https://github.com/nodejs/node-gyp/issues/454).

So the default command is `su myrmex -c "npm install --production"`, `myrmex` beeing the name of the non root user.

## What's next?

Support python
