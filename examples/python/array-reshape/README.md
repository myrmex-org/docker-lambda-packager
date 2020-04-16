# Lambda with numpy dependency

This Lambda function create and reshape an array with the package [`numpy`](https://numpy.org/) that has C bindings.


## Packaging

The following command will create a `package.zip` file that can be used as a lambda package.

```bash
docker run \
    -v `pwd`:/workspace/sources \
    -v /path/to/result/directory:/workspace/package \
    myrmex/lambda-packager:python-3.8
```
