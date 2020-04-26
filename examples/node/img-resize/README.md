# Lambda performing image resizing

This Lambda function resizes and image with the module [`sharp`](https://www.npmjs.com/package/sharp) that has C++ bindings.


## Packaging

The following command will create a `package.zip` file that can be used as a lambda package.

```bash
docker run -it \
    -v `pwd`:/workspace/sources \
    -v /path/to/result/directory:/workspace/package \
    myrmex/lambda-packager:node-12
```
