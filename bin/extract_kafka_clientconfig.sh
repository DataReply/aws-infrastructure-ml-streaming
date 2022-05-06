#!/bin/bash
CLUSTER_NAME=${1:-k3s-cluster}

mkdir -p ./tmp
export KUBECONFIG=$(PWD)/$CLUSTER_NAME.yaml

kubectl --kubeconfig k3s-cluster.yaml -n strimzi  get secrets  kafka-cluster-ca-cert -o json | jq -r '.data | map_values(@base64d) | ."ca.crt" ' > ./tmp/ca.crt
rm ./tmp/truststore.jks
keytool -import -keystore ./tmp/truststore.jks -alias CARoot -file ./tmp/ca.crt -noprompt -storepass kafka12

export BOOTSTRAP=$(kubectl --kubeconfig k3s-cluster.yaml -n strimzi get svc kafka-kafka-external-bootstrap -o json | jq -r ".status.loadBalancer.ingress[0].hostname")
export PORT=$(kubectl --kubeconfig k3s-cluster.yaml -n strimzi get svc kafka-kafka-external-bootstrap -o json | jq -r ".spec.ports[0].port")

export SASL_PASSWORD=$(kubectl --kubeconfig k3s-cluster.yaml -n strimzi  get secrets admin -o json | jq -r '.data | map_values(@base64d) | .password')

export SASL_JAAS_CONFIG="org.apache.kafka.common.security.scram.ScramLoginModule required username=\"admin\" password=\"$SASL_PASSWORD\";"

echo SASL_JAAS_CONFIG
echo "bootstrap.servers=$BOOTSTRAP:$PORT
sasl.jaas.config=$SASL_JAAS_CONFIG
security.protocol= SASL_SSL
sasl.mechanism=SCRAM-SHA-512
ssl.truststore.location=$(pwd)/tmp/truststore.jks
ssl.truststore.password: kafka12" > ./tmp/kafka-config.txt

cat ./tmp/kafka-config.txt
