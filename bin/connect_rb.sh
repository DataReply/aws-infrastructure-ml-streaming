#!/bin/bash
CLUSTER_NAME=${1:-k3s-rb-cluster}

export KUBECONFIG=$(PWD)/$CLUSTER_NAME.yaml

INSTANCE_ID=$(aws ssm describe-instance-information  --profile datareply | jq -r '.InstanceInformationList[] | select(.Name == "raspberry") | .InstanceId ')
aws ssm start-session --profile datareply  \
    --target $INSTANCE_ID  \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["6443"], "localPortNumber":["6443"]}'&
