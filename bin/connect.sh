#!/bin/bash
CLUSTER_NAME=${1:-k3s-cluster}

export KUBECONFIG=$(PWD)/$CLUSTER_NAME.yaml

INSTANCE_ID=$(aws ec2 describe-instances --profile "datareply" --filters Name=tag:Name,Values=k3s-cluster-master Name=instance-state-name,Values=running | jq '.Reservations[0].Instances[0].InstanceId' -r)
aws ssm start-session --profile datareply  \
    --target $INSTANCE_ID  \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["6443"], "localPortNumber":["6443"]}'&
