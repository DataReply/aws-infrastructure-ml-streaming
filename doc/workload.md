```
pip install gsutil
```

![cifar model lgtm](https://pytorch.org/tutorials/_images/cifar10.png "cifar")

```
gsutil cp gs://seldon-datasets/cifar10/requests/tensorflow/cifar10_tensorflow.json.gz cifar10_tensorflow.json.gz
gunzip cifar10_tensorflow.json.gz
gsutil cp gs://seldon-datasets/cifar10/requests/tensorflow/cifar10_tensorflow.proto cifar10_tensorflow.proto
```
../bin/extract_kafka_clientconfig.sh
to set SASL_PASSWORD 

```
pipenv --python 3.7
pipenv install
pipenv run  python test-client.py produce a17a5c2e5b50247f6a7504d3d3afc7b7-742107535.eu-central-1.elb.amazonaws.com:9094 $SASL_PASSWORD cifar10-rest-input --file cifar10_tensorflow.json

pipenv run  python test-client.py consume a17a5c2e5b50247f6a7504d3d3afc7b7-742107535.eu-central-1.elb.amazonaws.com:9094 $SASL_PASSWORD cifar10-rest-output 
```