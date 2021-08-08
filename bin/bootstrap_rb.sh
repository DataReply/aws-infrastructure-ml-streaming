#!/bin/bash
CLUSTER_NAME=${1:-k3s-rb-cluster}

INSTANCE_ID=$(aws ssm describe-instance-information  --profile datareply | jq -r '.InstanceInformationList[] | select(.Name == "raspberry") | .InstanceId ')
COMMAND_ID=$(aws ssm send-command --profile "datareply"  \
    --document-name "AWS-RunShellScript" \
    --parameters 'commands=["cat /etc/rancher/k3s/k3s.yaml"]' \
    --targets "Key=instanceids,Values=$INSTANCE_ID" | jq '.Command.CommandId' -r )
sleep 10

aws ssm  get-command-invocation --profile "datareply" \
--command-id $COMMAND_ID \
--instance-id $INSTANCE_ID | jq '.StandardOutputContent' -r > $CLUSTER_NAME.yaml
export KUBECONFIG=$(PWD)/$CLUSTER_NAME.yaml
