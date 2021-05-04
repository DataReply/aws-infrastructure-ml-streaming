#!/bin/bash
mkdir -p ./tmp
kubectl -n strimzi  get secrets  kafka-cluster-ca-cert -o json | jq -r '.data | map_values(@base64d) | ."ca.crt" ' > ./tmp/ca.crt
keytool -import -keystore ./tmp/truststore.jks -alias CARoot -file ./tmp/ca.crt -noprompt -storepass kafka12

export BOOTSTRAP=$(kubectl -n strimzi get svc kafka-kafka-external-bootstrap -o json | jq -r ".status.loadBalancer.ingress[0].hostname")
export PORT=$(kubectl -n strimzi get svc kafka-kafka-external-bootstrap -o json | jq -r ".spec.ports[0].port")

export SASL_PASSWORD=$(kubectl -n strimzi  get secrets admin -o json | jq -r '.data | map_values(@base64d) | .password')

cat << EOF
bootstrap.servers=$BOOTSTRAP:$PORT
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="admin" password="$SASL_PASSWORD";
security.protocol= SASL_SSL
sasl.mechanism=SCRAM-SHA-512
ssl.truststore.location=$(pwd)/tmp/truststore.jks
ssl.truststore.password: kafka12
EOF