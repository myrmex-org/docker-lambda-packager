import json

import numpy as np

def lambda_handler(event, context):
    a = np.arange(15).reshape(3, 5)
    print(a)
    return {
        "statusCode": 200,
        "headers": { "Content-Type": "text/plain" },
        "body": f"{a}"
    }
