#!/bin/bash
mkdir -p ./tmp
export KUBECONFIG=$(PWD)/k3s.yaml

kubectl -n strimzi  get secrets  kafka-cluster-ca-cert -o json | jq -r '.data | map_values(@base64d) | ."ca.crt" ' > ./tmp/ca.crt

export BOOTSTRAP_URL=$(kubectl -n strimzi get svc kafka-kafka-external-bootstrap -o json | jq -r ".status.loadBalancer.ingress[0].hostname")
export KAFKA_PORT=$(kubectl -n strimzi get svc kafka-kafka-external-bootstrap -o json | jq -r ".spec.ports[0].port")

export SASL_PASSWORD=$(kubectl -n strimzi  get secrets admin -o json | jq -r '.data | map_values(@base64d) | .password')