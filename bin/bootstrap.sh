#!/bin/bash
CLUSTER_NAME=${1:-k3s-cluster}

INSTANCE_ID=$(aws ec2 describe-instances --profile "datareply" --filters "Name=tag:Name,Values=$CLUSTER_NAME-master" | jq '.Reservations[0].Instances[0].InstanceId' -r)
COMMAND_ID=$(aws ssm send-command --profile "datareply"  \
    --document-name "AWS-RunShellScript" \
    --parameters 'commands=["cat /etc/rancher/k3s/k3s.yaml"]' \
    --targets "Key=instanceids,Values=$INSTANCE_ID" | jq '.Command.CommandId' -r )
sleep 10

aws ssm  get-command-invocation --profile "datareply" \
--command-id $COMMAND_ID \
--instance-id $INSTANCE_ID | jq '.StandardOutputContent' -r > $CLUSTER_NAME.yaml
export KUBECONFIG=$(PWD)/$CLUSTER_NAME.yaml
