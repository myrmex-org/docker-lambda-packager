# Docker image to create Amazon Lambda packages

The usage of this tool changed a lot in April 2020. For the former usage, please check the branch
[`legacy`](https://github.com/myrmex-org/docker-lambda-packager/tree/legacy).

## Why?

Some node and python modules require a build system because they contain c++ binding. Once deployed, the compiled
module may not be compatible with the Amazon Lambda execution environment.

A common solution to this problem is to build the package on an EC2 instance using an Amazon Linux AMI and then to
deploy it in Amazon Lambda. Building serverless applications, it is ironic to be forced to use an EC2 server to deploy code.

These docker images are based on the [Amazon Linux](https://hub.docker.com/_/amazonlinux/) image and contains libs
required to install common python and NodeJS dependencies.

Using `myrmex/lambda-packager` docker images, you can avoid errors like these during execution in Amazon Lambda:

```
/var/lang/lib/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by /var/task/node_modules/bcrypt/lib/binding/bcrypt_lib.node)
```

```
Module version mismatch. Expected 46, got 48.
```

## Usage

You can use docker volumes to mount the code of the Lambda in a container and retrieve a generated zip archive.
The directory where the source files must be mounted is `/workspace/sources`. The zip archive is generated in the `/workspace/package`
directory in the container.

The generated zip archive can be used as an AWS Lambda deployment package. Check the examples in this repository.

### Node.js

The default command of `myrmex/lambda-packager:node-12` will install the dependencies defined in the `package.json` file.

```bash
docker run \
    -v `pwd`:/workspace/sources \
    -v /path/to/result/directory:/workspace/sources \
    myrmex/lambda-packager:node-12
```

The archive `/path/to/result/directory/package.zip` can then be used as a Node.js Lambda package.

### Python

The default command of `myrmex/lambda-packager:python-3.8` will install the dependencies defined in the `requirements.txt` file.

```bash
docker run \
    -v `pwd`:/workspace/sources \
    -v /path/to/result/directory:/workspace/sources \
    myrmex/lambda-packager:python-3.8
```

The archive `/path/to/result/directory/package.zip` can then be used as a python Lambda package.


### Excluding files from the package

Before installing dependencies, the container copy the source files in a clean directory with `rsync`.

The environment variable `RSYNC_OPTIONS` allows to pass options for this `rsync` command. It is useful to exclude some
files from the generated zip archive.

For Node.js the default value of `RSYNC_OPTIONS` is `--exclude node_modules` to enforce a clean installation.

For Python the default value of `RSYNC_OPTIONS` is `--exclude venv --exclude .venv` to avoid including useless virtual environnement
in the zip archive.

**example**

If one also wants to exclude a `docs` directory and a `README.md` file for the generated archive, he can use the following command:

```bash
docker run \
    -e RSYNC_OPTIONS="--exclude node_modules --exclude docs --exclude README.md"
    -v `pwd`:/workspace/sources \
    -v /path/to/result/directory:/workspace/sources \
    myrmex/lambda-packager:node-12
```