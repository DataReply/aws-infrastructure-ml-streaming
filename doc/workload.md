# Run CIFAR10 classification workload

![cifar model lgtm](https://pytorch.org/tutorials/_images/cifar10.png "cifar")


## Prepration

Make sure to have installed gsutil:

```
pip install gsutil
```

and obtain the sampe data needed to cary out the workload:

```
gsutil cp gs://seldon-datasets/cifar10/requests/tensorflow/cifar10_tensorflow.json.gz cifar10_tensorflow.json.gz
gunzip cifar10_tensorflow.json.gz
gsutil cp gs://seldon-datasets/cifar10/requests/tensorflow/cifar10_tensorflow.proto cifar10_tensorflow.proto
```

## Run Workload

Run the bootstrap_model script to ensure required variables set.

```
. ../bin/bootstrap_model.sh
```

Make sure to use a compatible python version (compatible with the tensorflow lib [we use only helpers] )
```
pipenv --python 3.7
pipenv install
```

First generate some data, then read the yielded prediction stream
```
pipenv run python test-client.py produce $BOOTSTRAP_URL:$KAFKA_PORT $SASL_PASSWORD cifar10-rest-input --file cifar10_tensorflow.json
pipenv run python test-client.py consume $BOOTSTRAP_URL:$KAFKA_PORT $SASL_PASSWORD cifar10-rest-output 
```