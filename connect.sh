#!/bin/bash

INSTANCE_ID=$(aws ec2 describe-instances --profile "datareply" --filters "Name=tag:k3s-role,Values=master" | jq '.Reservations[0].Instances[0].InstanceId' -r)
aws ssm start-session --profile datareply  \
    --target $INSTANCE_ID  \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["6443"], "localPortNumber":["6443"]}'